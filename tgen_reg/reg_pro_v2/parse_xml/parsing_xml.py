#!/usr/bin/python3
# coding=utf-8
import copy
from xml.dom.minidom import parse
import math
import re
import sys
import os
import time
import collections
import shutil


# import glob


def gen_file(f_path, f_name, f_context):
    if os.path.exists(f_path) is False:
        os.makedirs(f_path)
    file_name = os.path.abspath(os.path.join(f_path, f_name))
    file = open(file_name, "w")
    file.write(f_context)
    file.close()


def gen_project_list(root):
    project_name = root.getElementsByTagName('prj_name')[0].childNodes[0].data.replace(' ', '')
    project_baddr = root.getElementsByTagName('prj_base_address')[0].childNodes[0].data.replace(' ', '')
    project_dw = int(
        re.sub(r'\D', '', root.getElementsByTagName('prj_data_width')[0].childNodes[0].data.replace(' ', '')))
    all_register_list = root.getElementsByTagName('all_register')
    id_set = set()
    if root.getAttribute('id'):
        id_set.add(root.getAttribute('id'))
    for tmp_all_register in all_register_list:
        if tmp_all_register.getAttribute('id'):
            id_set.add(tmp_all_register.getAttribute('id'))
    project_list = [project_name, project_baddr, project_dw, id_set]
    return project_list


def gen_block_map_dict(root, project_list):
    project_baddr = project_list[1]
    project_dw = project_list[2]
    block_map_list = root.getElementsByTagName('block_map')
    # block_map_dict = {}
    block_names = set()
    block_id_dict = collections.OrderedDict()
    block_map_dict = collections.OrderedDict()
    used_address_dict = collections.OrderedDict()
    used_addr_offset = 0
    for block in block_map_list:
        block_name = block.getElementsByTagName('block_name')[0].childNodes[0].data.replace(' ', '')
        if block.parentNode.getAttribute('id'):
            block_id = block.parentNode.getAttribute('id')
        else:
            block_id = block_name
        if not block_name in block_id_dict.keys():
            block_id_dict[block_name] = block_id
        else:
            print('Error::::Repeat module description,block_name=【{}】,module_id1=【{}】,module_id2=【{}】'.format(
                block_name, block_id, block_id_dict[block_name]))
    print('id=', block_id_dict)
    for block in block_map_list:
        block_name = block.getElementsByTagName('block_name')[0].childNodes[0].data.replace(' ', '')
        if block_name not in block_names:
            block_names.add(block_name)
        else:
            raise Exception("block_map duplicate declaration,block_name=【%s】" % block_name)
        block_base_address = project_baddr
        block_offset = block.getElementsByTagName('block_offset')[0].childNodes[0].data.replace(' ', '')
        block_data_width = int(re.sub(r'\D', '', block.getElementsByTagName('data_width')[0].childNodes[0].data))
        block_size = block.getElementsByTagName('block_size')[0].childNodes[0].data.replace(' ', '')
        if block.getElementsByTagName('instance_number'):
            instance_number = block.getElementsByTagName('instance_number')[0].childNodes[0].data.replace(' ', '')
        else:
            instance_number = 1
        if block.getElementsByTagName('block_description'):
            block_description = block.getElementsByTagName('block_description')[0].childNodes[0].data
        else:
            block_description = 'hello,world'
        if project_dw != block_data_width:
            print('Warning::::the project width({}bits) != the {} width({}bits)'.format(project_dw, block_name,
                                                                                        block_data_width))
        if int(re.sub('0x', '', block_offset), 16) % 256 != 0:
            print('Warning::::The block_offset is set incorrectly,not a multiple of 256,block_name=【{}】,'
                  'block_offset=【{}】'.format(block_name, block_offset))
        if int(re.sub('Bytes', '', block_size), 10) % 256 != 0:
            print('Warning::::The block_size is set incorrectly,not a multiple of 256,block_name=【{}】,'
                  'block_size=【{}】'.format(block_name, block_size))
        # if used_addr_offset > int(re.sub('0x', '', block_offset), 16):
        #    print('Error::::The start address of the block has been used,block_name=【{}】,block_offset=【{}】,'
        #          'used_addr_offset=【{}】'.format(block_name, block_offset, hex(used_addr_offset)))
        # used_addr_offset = int(re.sub('0x', '', block_offset), 16) + int(re.sub('Bytes', '', block_size), 10)
        address_min = int(re.sub('0x', '', block_offset), 16)
        address_max = address_min + int(re.sub('Bytes', '', block_size), 10) * int(instance_number)
        for tmp_block_name in used_address_dict.keys():
            tmp_address_min = int(re.sub('0x', '', used_address_dict[tmp_block_name][0]), 16)
            tmp_address_max = tmp_address_min + int(re.sub('Bytes', '', used_address_dict[tmp_block_name][1]),
                                                    10) * int(used_address_dict[tmp_block_name][2])
            if address_max > tmp_address_min and address_min < tmp_address_min:
                print('Error::::Module address stampede,block_name1=【{}】,block_name2=【{}】,'
                      'module_id1=【{}】,module_id2=【{}】'.format(
                    tmp_block_name, block_name, block_id_dict[tmp_block_name], block_id_dict[block_name]))
            if address_max > tmp_address_max and address_min < tmp_address_max:
                print('Error::::Module address stampede,block_name1=【{}】,block_name2=【{}】,'
                      'module_id1=【{}】,module_id2=【{}】'.format(
                    tmp_block_name, block_name, block_id_dict[tmp_block_name], block_id_dict[block_name]))
            if address_max < tmp_address_max and address_min > tmp_address_min:
                print('Error::::Module address stampede,block_name1=【{}】,block_name2=【{}】,'
                      'module_id1=【{}】,module_id2=【{}】'.format(
                    tmp_block_name, block_name, block_id_dict[tmp_block_name], block_id_dict[block_name]))
        if not block_name in used_address_dict.keys():
            used_address_dict[block_name] = [block_offset, block_size, instance_number, block_base_address]
        else:
            print('Error::::Repeat module description,block_name=【{}】'.format(block_name))
        block_map_dict[block_name] = (block_base_address, block_offset, block_data_width, block_size,
                                      block_description, instance_number, block_id_dict[block_name])
    # print('1>>>>{}'.format(block_map_dict))
    gen_block_gap_reserved_addr(used_address_dict)
    return block_map_dict


def gen_block_gap_reserved_addr(address_dict):
    block_addr_boundarys = []
    reserved_addrs = set()
    for block_name in address_dict.keys():
        tmp_address_min = int(re.sub('0x', '', address_dict[block_name][0]), 16) + int(
            re.sub('0x', '', address_dict[block_name][3]), 16)
        tmp_address_max = tmp_address_min + int(re.sub('Bytes', '', address_dict[block_name][1]),
                                                10) * int(address_dict[block_name][2])
        block_addr_boundarys.append(tmp_address_min)
        block_addr_boundarys.append(tmp_address_max)
    block_addr_boundarys.sort()
    block_addr_boundarys_hex = []
    [block_addr_boundarys_hex.append(hex(block_addr_boundary)) for block_addr_boundary in block_addr_boundarys]
    print('block_addr_boundarys=', block_addr_boundarys_hex)
    if len(block_addr_boundarys) > 2:
        for i in range(0, int(len(block_addr_boundarys) / 2) - 1):
            if block_addr_boundarys[i * 2 + 2] > block_addr_boundarys[i * 2 + 1]:
                upper_addr = int(block_addr_boundarys[i * 2 + 2])
                lower_addr = int(block_addr_boundarys[i * 2 + 1])
                for j in range(0, (int(upper_addr) - int(lower_addr)) // 4):
                    tmp_reserved_addr = hex(lower_addr + 4 * int(j))
                    reserved_addrs.add(tmp_reserved_addr)
    print('block_gap_reserved_addr_number=', len(reserved_addrs))


def gen_subblock_dict_ipxact(root, block_map_dict):
    subblock_list = root.getElementsByTagName('spirit:addressBlock')
    subblock_dict = collections.OrderedDict()
    subblock_dict_incd_reserved = collections.OrderedDict()
    subblock_addr_dict = collections.OrderedDict()
    for subblock in subblock_list:
        subblock_name = subblock.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
        if subblock_name in block_map_dict.keys():
            block_base_address = int(re.sub('0x', '', block_map_dict[subblock_name][0]), 16)
            block_offset = int(re.sub('0x', '', block_map_dict[subblock_name][1]), 16)
            register_list = subblock.getElementsByTagName('spirit:register')
            subblock_dw = block_map_dict[subblock_name][2]
            block_size = int(re.sub('Bytes', '', block_map_dict[subblock_name][3]), 10)
            pre_offset_step = math.ceil(subblock_dw / 8)
            reg_offset_step = pre_offset_step
            reg_offset = 0 - reg_offset_step
            subblock_reg_list = []
            subblock_reg_list_incd_reserved = []
            subblock_addr_list = []
            reserved_addrs = []
            reg_names = set()
            for register in register_list:
                reg_name = register.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
                if reg_name not in reg_names:
                    reg_names.add(reg_name)
                else:
                    raise Exception("register duplicate declaration,subblock_name=【%s】,"
                                    "reg_name=【%s】" % (subblock_name, reg_name))
                if register.getElementsByTagName('spirit:size'):
                    reg_width = int(
                        re.sub(r'\D', '', register.getElementsByTagName('spirit:size')[0].childNodes[0].data))
                    reg_offset_step = math.ceil(reg_width / 8)
                else:
                    reg_width = subblock_dw
                if register.getElementsByTagName('spirit:addressOffset'):
                    tmp_reg_offset = int(
                        re.sub("'h", '',
                               register.getElementsByTagName('spirit:addressOffset')[0].childNodes[0].data), 16)
                    if reg_offset + reg_offset_step > tmp_reg_offset:
                        print('Error::::The start address of the reg has been used,block_name=【{}】,reg_name=【{}】,'
                              'reg_offset=【{}】,used_reg_offset=【{}】'.format(
                            subblock_name, reg_name, hex(tmp_reg_offset), hex(reg_offset + reg_offset_step - 4)))
                    if tmp_reg_offset > reg_offset + reg_offset_step:
                        for i in range(0, (tmp_reg_offset - (reg_offset + reg_offset_step)) // 4):
                            reserved_addrs.append(reg_offset + reg_offset_step + i * 4)
                    if tmp_reg_offset % 4 != 0:
                        print('Error::::The address is set incorrectly,not a multiple of 4,block_name=【{}】,'
                              'reg_name=【{}】,reg_offset=【{}】'.format(subblock_name, reg_name, hex(tmp_reg_offset)))
                    reg_offset = tmp_reg_offset
                else:
                    reg_offset += reg_offset_step
                if reg_offset > block_size:
                    print('Error::::The address is set incorrectly,register address overflow,block_name=【{}】,'
                          'reg_name=【{}】,reg_offset=【{}】,block_size=【{}】'.format(subblock_name, reg_name,
                                                                                 hex(reg_offset), hex(block_size)))
                reg_type = 'register'
                if register.getElementsByTagName('spirit:usageType'):
                    reg_type = register.getElementsByTagName('spirit:usageType')[0].childNodes[0].data.replace(' ',
                                                                                                               '')
                if register.getElementsByTagName('spirit:reg_depth'):
                    reg_depth = int(
                        re.sub("'h", '', register.getElementsByTagName('spirit:reg_depth')[0].childNodes[0].data),
                        16)
                    reg_offset_step = reg_depth
                else:
                    reg_depth = 1
                    reg_offset_step = pre_offset_step
                if register.getElementsByTagName('spirit:size'):
                    reg_width = int(
                        re.sub(r'\D', '', register.getElementsByTagName('spirit:size')[0].childNodes[0].data))
                    reg_offset_step = math.ceil(reg_width / 8)
                else:
                    reg_width = subblock_dw
                    reg_offset_step = pre_offset_step
                field_property_list = []
                field_property_list_incd_reserved = []
                used_field_offset = 0
                field_names = set()
                field_init_value = ''
                for field in register.getElementsByTagName('spirit:field'):
                    field_name = field.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
                    if field_name not in field_names:
                        field_names.add(field_name)
                    else:
                        raise Exception("field duplicate declaration,subblock_name=【%s】,reg_name=【%s】,"
                                        "field_name=【%s】" % (subblock_name, reg_name, field_name))
                    field_offset = field.getElementsByTagName('spirit:bitOffset')[0].childNodes[0].data.replace(' ',
                                                                                                                '')
                    field_width = field.getElementsByTagName('spirit:bitWidth')[0].childNodes[0].data.replace(' ',
                                                                                                              '')
                    if field.getElementsByTagName('spirit:access'):
                        field_access_name = field.getElementsByTagName('spirit:access')[0].childNodes[0].data
                    else:
                        field_access_name = register.getElementsByTagName('spirit:access')[0].childNodes[0].data
                    # unify the name of field_access in ipxact and uvm
                    if field_access_name == 'read-only':
                        field_access = 'RO'
                    elif field_access_name == 'write-only':
                        field_access = 'WO'
                    elif field_access_name == 'read-write':
                        field_access = 'RW'
                    elif field_access_name == 'writeOnce':
                        field_access = 'WO1'
                    elif field_access_name == 'read-writeOnce':
                        field_access = 'W1'
                    else:
                        field_access = field_access_name
                    '''''''''''
                        #field_init_value is enumeratedValues-IDLE
                        if field.getElementsByTagName('spirit:enumeratedValues'):
                            for enumeratedValue in field.getElementsByTagName('spirit:enumeratedValues'):
                                enumeratedValue_name = enumeratedValue.getElementsByTagName('spirit:name')[0].childNodes[0].data
                                if enumeratedValue_name == 'IDLE':
                                    field_init_value = hex(int(enumeratedValue.getElementsByTagName('spirit:value')[0].childNodes[0].data.replace(
                                        ' ', '')))
                        else:
                            field_init_value = '0x0'
                        '''''''''''
                    # field_init_value is reset
                    if field.getElementsByTagName('spirit:resets'):
                        for reset in field.getElementsByTagName('spirit:resets'):
                            field_init_value = hex(
                                int(reset.getElementsByTagName('spirit:value')[0].childNodes[0].data.replace("'h", ''),
                                    16))
                    else:
                        field_init_value = '0x0'
                    if field.getElementsByTagName('spirit:description'):
                        field_description = field.getElementsByTagName('spirit:description')[0].childNodes[0].data
                    else:
                        field_description = 'none'
                    if field_access not in ['RO', 'WO', 'RW', 'W1', 'WO1', 'RU'
                                            'W1S', 'RC', 'W1C', 'WRC', 'RWHW']:
                        print(
                            'Error::::The field_access is not support and replace it with other types,block_name=【{}】,'
                            'reg_name=【{}】,field_name=【{}】,field_access=【{}】'.format(
                                subblock_name, reg_name, field_name, field_access))
                    if int(int(int(field_offset) % 32) + int(field_width)) > 32:
                        print('Error::::Field domain crosses the boundary,block_name=【{}】,'
                              'reg_name=【{}】,field_name=【{}】,field_offset=【{}】,field_width=【{}】'.format(
                            subblock_name, reg_name, field_name, field_offset, field_width))
                    if int(re.sub('0x', '', field_init_value), 16) >= 1 << int(field_width):
                        print('Error::::The field_init_value is set inappropriate,has overflowed,block_name=【{}】,'
                              'reg_name=【{}】,field_name=【{}】,field_width=【{}】,field_init_value=【{}】'.format(
                            subblock_name, reg_name, field_name, field_width, field_init_value))
                    if int(field_offset) % 4 != 0:
                        print(
                            'Warning::::The field_offset is set inappropriate,not a multiple of 4,block_name=【{}】,'
                            'reg_name=【{}】,field_name=【{}】,field_offset=【{}】'.format(
                                subblock_name, reg_name, field_name, field_offset))
                    if int(used_field_offset) > int(field_offset):
                        print('Error::::The start field_offset of the field has been used,block_name=【{}】,'
                              'reg_name=【{}】,field_name=【{}】,field_offset=【{}】,used_field_offset=【{}】'.format(
                            subblock_name, reg_name, field_name, field_offset, used_field_offset))
                    if int(field_offset) > int(used_field_offset):
                        reserved_width = int(field_offset) - int(used_field_offset)
                        field_property_list_incd_reserved.append(
                            ('Reserved', used_field_offset, reserved_width, 'NA', "0x0",
                             'reserved', ''))
                    used_field_offset = int(field_offset) + int(field_width)
                    if field.getElementsByTagName('spirit:field_hdl_path'):
                        field_hdl_path = field.getElementsByTagName('spirit:field_hdl_path')[0].childNodes[
                            0].data.replace(' ',
                                            '')
                    else:
                        if int(reg_width) > 32:
                            num32 = int(int(field_offset) / 32)
                            field_hdl_path = '''u_r_{}_{}_{}.u_f_{}'''.format(reg_name, int(num32 * 32),
                                                                              int((num32 + 1) * 32 - 1),
                                                                              field_name).replace(' ', '')
                        else:
                            field_hdl_path = 'u_r_{}.u_f_{}'.format(reg_name, field_name).replace(' ', '')
                    field_property_list.append(
                        (field_name, field_offset, field_width, field_access, field_init_value,
                         field_description, field_hdl_path))
                    field_property_list_incd_reserved.append(
                        (field_name, field_offset, field_width, field_access, field_init_value,
                         field_description, field_hdl_path))
                if int(used_field_offset) % 32 != 0:
                    boundary_width = (int(int(used_field_offset) / 32) + 1) * 32
                    reserved_width = int(boundary_width) - int(used_field_offset)
                    field_property_list_incd_reserved.append(
                        ('Reserved', used_field_offset, reserved_width, 'NA', "0x0",
                         'reserved', ''))
                subblock_reg_list.append(
                    (reg_name, hex(reg_offset), reg_type, reg_depth, reg_width, field_property_list, 1))
                subblock_reg_list_incd_reserved.append(
                    (reg_name, hex(reg_offset), reg_type, reg_depth, reg_width, field_property_list_incd_reserved, 1))

            subblock_addr_list = [reg_offset, block_size, block_offset, block_base_address,
                                  reserved_addrs]
            subblock_addr_dict[subblock_name] = subblock_addr_list
            subblock_dict[subblock_name] = subblock_reg_list
            subblock_dict_incd_reserved[subblock_name] = subblock_reg_list_incd_reserved
        else:
            print("Error::::Sub block name Error,not belong sys_reg,please check the xml subblock_name=【{}】".format(
                subblock_name))
        # sys.exit()
    return subblock_dict, subblock_dict_incd_reserved, subblock_addr_dict


def gen_subblock_dict(root, block_map_dict):
    subblock_list = root.getElementsByTagName('subblock')
    # subblock_dict = {}
    subblock_dict = collections.OrderedDict()
    subblock_dict_incd_reserved = collections.OrderedDict()
    subblock_addr_dict = collections.OrderedDict()
    for subblock in subblock_list:
        subblock_name = subblock.getElementsByTagName('subblock_name')[0].childNodes[0].data.replace(' ', '')
        if subblock_name in block_map_dict.keys():
            if subblock.getElementsByTagName('ip_xact_url'):
                ip_xact_url = subblock.getElementsByTagName('ip_xact_url')[0].childNodes[0].data.replace(' ', '')
                ip_reg_tree = parse(ip_xact_url)
                ip_root = ip_reg_tree.documentElement
                subblock_dict_ipxact, subblock_dict_incd_reserved_ipxact, subblock_addr_dict_ipxact \
                    = gen_subblock_dict_ipxact(ip_root, block_map_dict)
                subblock_dict.update(subblock_dict_ipxact)
                subblock_dict_incd_reserved.update(subblock_dict_incd_reserved_ipxact)
                subblock_addr_dict.update(subblock_addr_dict_ipxact)
            elif subblock.getElementsByTagName('ip_xml_url'):
                ip_xml_url = subblock.getElementsByTagName('ip_xml_url')[0].childNodes[0].data.replace(' ', '')
                ip_reg_tree = parse(ip_xml_url)
                ip_root = ip_reg_tree.documentElement
                subblock_reg_list, subblock_reg_list_incd_reserved, subblock_addr_list = gen_oneblock_reg_list(
                    subblock_name, ip_root, block_map_dict)
                subblock_dict[subblock_name] = subblock_reg_list
                subblock_dict_incd_reserved[subblock_name] = subblock_reg_list_incd_reserved
                subblock_addr_dict[subblock_name] = subblock_addr_list
            else:
                subblock_reg_list, subblock_reg_list_incd_reserved, subblock_addr_list = gen_oneblock_reg_list(
                    subblock_name, subblock, block_map_dict)
                subblock_dict[subblock_name] = subblock_reg_list
                subblock_dict_incd_reserved[subblock_name] = subblock_reg_list_incd_reserved
                subblock_addr_dict[subblock_name] = subblock_addr_list
        else:
            print("Error::::Sub block name Error,not belong sys_reg,please check the xml subblock_name=【{}】".format(
                subblock_name))
            # sys.exit()
    # for key in subblock_dict.keys():
    #     print('2>>>>{}::::{}'.format(key, subblock_dict[key]))
    print('subblock_addr_dict=', subblock_addr_dict)
    gen_block_internal_reserved_addr(subblock_addr_dict)
    return subblock_dict, subblock_dict_incd_reserved


def gen_oneblock_reg_list(subblock_name, subblock, block_map_dict):
    block_base_address = int(re.sub('0x', '', block_map_dict[subblock_name][0]), 16)
    block_offset = int(re.sub('0x', '', block_map_dict[subblock_name][1]), 16)
    reserved_addrs = []
    register_list = subblock.getElementsByTagName('register')
    subblock_dw = block_map_dict[subblock_name][2]
    block_size = int(re.sub('Bytes', '', block_map_dict[subblock_name][3]), 10)
    pre_offset_step = math.ceil(subblock_dw / 8)
    reg_offset_step = pre_offset_step
    reg_offset = 0 - reg_offset_step
    subblock_reg_list = []
    subblock_reg_list_incd_reserved = []
    reg_names = set()
    for register in register_list:
        if register.getElementsByTagName('reg_number'):
            reg_number = register.getElementsByTagName('reg_number')[0].childNodes[0].data.replace(' ', '')
        else:
            reg_number = 1
        for ii in range(0, int(reg_number)):
            if int(reg_number) > 1:
                reg_name = register.getElementsByTagName('reg_name')[0].childNodes[0].data.replace(' ', '') + str(ii)
            else:
                reg_name = register.getElementsByTagName('reg_name')[0].childNodes[0].data.replace(' ', '')
            if register.getElementsByTagName('reg_width'):
                reg_width = int(re.sub(r'\D', '', register.getElementsByTagName('reg_width')[0].childNodes[0].data))
            else:
                reg_width = subblock_dw
            if reg_name not in reg_names:
                reg_names.add(reg_name)
            else:
                raise Exception("register duplicate declaration,subblock_name=【%s】,"
                                "reg_name=【%s】" % (subblock_name, reg_name))
            if register.getElementsByTagName('reg_offset'):
                tmp_reg_offset = int(
                    re.sub('0x', '', register.getElementsByTagName('reg_offset')[0].childNodes[0].data),
                    16) + ii * (reg_width // 8)
                if reg_offset + reg_offset_step > tmp_reg_offset:
                    print('Error::::The start address of the reg has been used,block_name=【{}】,reg_name=【{}】,'
                          'reg_offset=【{}】,used_reg_offset=【{}】'.format(
                        subblock_name, reg_name, hex(tmp_reg_offset), hex(reg_offset + reg_offset_step - 4)))
                if tmp_reg_offset > reg_offset + reg_offset_step:
                    for i in range(0, (tmp_reg_offset - (reg_offset + reg_offset_step)) // 4):
                        reserved_addrs.append(reg_offset + reg_offset_step + i * 4)
                if tmp_reg_offset % 4 != 0:
                    print('Error::::The address is set incorrectly,not a multiple of 4,block_name=【{}】,'
                          'reg_name=【{}】,reg_offset=【{}】'.format(subblock_name, reg_name, hex(tmp_reg_offset)))
                reg_offset = tmp_reg_offset
            else:
                reg_offset += reg_offset_step
            if reg_offset > block_size:
                print('Error::::The address is set incorrectly,register address overflow,block_name=【{}】,'
                      'reg_name=【{}】,reg_offset=【{}】,block_size=【{}】'.format(subblock_name, reg_name,
                                                                             hex(reg_offset), hex(block_size)))
            reg_type = 'register'
            if register.getElementsByTagName('reg_type'):
                reg_type = register.getElementsByTagName('reg_type')[0].childNodes[0].data.replace(' ', '')
            if register.getElementsByTagName('reg_depth'):
                reg_depth = int(re.sub('0x', '', register.getElementsByTagName('reg_depth')[0].childNodes[0].data), 16)
            else:
                reg_depth = 1
            if register.getElementsByTagName('reg_width'):
                reg_width = int(re.sub(r'\D', '', register.getElementsByTagName('reg_width')[0].childNodes[0].data))
                reg_offset_step = math.ceil(reg_width / 8)
            else:
                reg_width = subblock_dw
                reg_offset_step = pre_offset_step
            field_property_list = []
            field_property_list_incd_reserved = []
            used_field_offset = 0
            field_names = set()
            for field in register.getElementsByTagName('field'):
                field_name = field.getElementsByTagName('field_name')[0].childNodes[0].data.replace(' ', '')
                if field_name not in field_names:
                    field_names.add(field_name)
                else:
                    raise Exception("field duplicate declaration,subblock_name=【%s】,reg_name=【%s】,"
                                    "field_name=【%s】" % (subblock_name, reg_name, field_name))
                field_offset = field.getElementsByTagName('field_offset')[0].childNodes[0].data.replace(' ', '')
                field_width = field.getElementsByTagName('field_width')[0].childNodes[0].data.replace(' ', '')
                field_access = field.getElementsByTagName('field_access')[0].childNodes[0].data.replace(' ', '')
                field_init_value = field.getElementsByTagName('field_init_value')[0].childNodes[0].data.replace(' ',
                                                                                                                '')
                field_description = field.getElementsByTagName('field_description')[0].childNodes[0].data
                if field_access not in ['RW', 'RWHW', 'WRC', 'W1C', 'W1S', 'WO', 'RC', 'RO' ,'RU']:
                    print(
                        'Error::::The field_access is not support and replace it with other types,block_name=【{}】,'
                        'reg_name=【{}】,field_name=【{}】,field_access=【{}】'.format(
                            subblock_name, reg_name, field_name, field_access))
                if int(int(int(field_offset) % 32) + int(field_width)) > 32:
                    print('Error::::Field domain crosses the boundary,block_name=【{}】,'
                          'reg_name=【{}】,field_name=【{}】,field_offset=【{}】,field_width=【{}】'.format(
                        subblock_name, reg_name, field_name, field_offset, field_width))
                if int(re.sub('0x', '', field_init_value), 16) >= 1 << int(field_width):
                    print('Error::::The field_init_value is set inappropriate,has overflowed,block_name=【{}】,'
                          'reg_name=【{}】,field_name=【{}】,field_width=【{}】,field_init_value=【{}】'.format(
                        subblock_name, reg_name, field_name, field_width, field_init_value))
                if int(field_offset) % 4 != 0:
                    print('Warning::::The field_offset is set inappropriate,not a multiple of 4,block_name=【{}】,'
                          'reg_name=【{}】,field_name=【{}】,field_offset=【{}】'.format(
                        subblock_name, reg_name, field_name, field_offset))
                if int(used_field_offset) > int(field_offset):
                    print('Error::::The start field_offset of the field has been used,block_name=【{}】,'
                          'reg_name=【{}】,field_name=【{}】,field_offset=【{}】,used_field_offset=【{}】'.format(
                        subblock_name, reg_name, field_name, field_offset, used_field_offset))
                if int(field_offset) > int(used_field_offset):
                    reserved_width = int(field_offset) - int(used_field_offset)
                    field_property_list_incd_reserved.append(
                        ('Reserved', used_field_offset, reserved_width, 'NA', "0x0", 'reserved', ''))
                used_field_offset = int(field_offset) + int(field_width)
                if field.getElementsByTagName('field_hdl_path'):
                    field_hdl_path = field.getElementsByTagName('field_hdl_path')[0].childNodes[0].data.replace(' ',
                                                                                                                '')
                else:
                    if int(reg_width) > 32:
                        num32 = int(int(field_offset) / 32)
                        field_hdl_path = '''u_r_{}_{}_{}.u_f_{}'''.format(reg_name, int(num32 * 32),
                                                                          int((num32 + 1) * 32 - 1),
                                                                          field_name).replace(' ', '')
                    else:
                        field_hdl_path = 'u_r_{}.u_f_{}'.format(reg_name, field_name).replace(' ', '')
                field_property_list.append((field_name, field_offset, field_width, field_access, field_init_value,
                                            field_description, field_hdl_path))
                field_property_list_incd_reserved.append(
                    (field_name, field_offset, field_width, field_access, field_init_value,
                     field_description, field_hdl_path))
            if int(used_field_offset) % 32 != 0:
                boundary_width = (int(int(used_field_offset) / 32) + 1) * 32
                reserved_width = int(boundary_width) - int(used_field_offset)
                field_property_list_incd_reserved.append(
                    ('Reserved', used_field_offset, reserved_width, 'NA', "0x0", 'reserved', ''))
            if ii == 0:
                subblock_reg_list.append(
                    (reg_name, hex(reg_offset), reg_type, reg_depth, reg_width, field_property_list, reg_number))
                subblock_reg_list_incd_reserved.append(
                    (reg_name, hex(reg_offset), reg_type, reg_depth, reg_width, field_property_list_incd_reserved, reg_number))
            else:
                subblock_reg_list.append(
                    (reg_name, hex(reg_offset), reg_type, reg_depth, reg_width, field_property_list, 1))
                subblock_reg_list_incd_reserved.append(
                    (reg_name, hex(reg_offset), reg_type, reg_depth, reg_width, field_property_list_incd_reserved, 1))
        ## Decimal
    subblock_addr_list = [reg_offset, block_size, block_offset, block_base_address, reserved_addrs]
    return subblock_reg_list, subblock_reg_list_incd_reserved, subblock_addr_list


def gen_block_internal_reserved_addr(subblock_addr_dict):
    for subblock_name in subblock_addr_dict.keys():
        reg_offset = subblock_addr_dict[subblock_name][0]
        block_size = subblock_addr_dict[subblock_name][1]
        block_offset = subblock_addr_dict[subblock_name][2]
        block_base_address = subblock_addr_dict[subblock_name][3]
        reserved_addrs = subblock_addr_dict[subblock_name][4]
        if "0x" in str(block_size):
            block_size = int(block_size.split("0x")[-1],16)
        print(block_size)           
        if int(block_size) > int(reg_offset):
            for i in range(0, (int(block_size) - int(reg_offset)) // 4):
                reserved_addrs.append(reg_offset + i * 4)


def paser_xml(level, xml_name):
    print(xml_name)
    reg_tree = parse(xml_name)
    root = reg_tree.documentElement
    if level == 'sys':
        project_list = gen_project_list(root)
        block_map_dict = gen_block_map_dict(root, project_list)
        subblock_dict, subblock_dict_incd_reserved = gen_subblock_dict(root, block_map_dict)
    elif level == 'blk':
        # project_name = (xml_name.split("\\")[-1]).split(".")[0]
        project_name = "prj_"
        project_name += os.path.split(xml_name)[-1].split(".")[0]
        project_list = [project_name, '0x0', 32, {project_name}]
        subblock_list = root.getElementsByTagName('subblock')
        block_map_dict = collections.OrderedDict()
        block_offset = 0
        block_base_address = hex(0)
        for subblock in subblock_list:
            if subblock.getElementsByTagName('instance_number'):
                instance_number = subblock.getElementsByTagName('instance_number')[0].childNodes[0].data.replace(' ',
                                                                                                                 '')
            else:
                instance_number = 1
            if subblock.getElementsByTagName('block_description'):
                block_description = subblock.getElementsByTagName('block_description')[0].childNodes[0].data
            else:
                block_description = 'hello,world'
            subblock_name = subblock.getElementsByTagName('subblock_name')[0].childNodes[0].data.replace(' ', '')
            print(subblock_name)
            block_id = subblock_name
            block_map_dict[subblock_name] = (
                block_base_address, hex(block_offset), 32, '4096Bytes', block_description, instance_number, block_id)
            block_offset += 4096
        subblock_dict, subblock_dict_incd_reserved = gen_subblock_dict(root, block_map_dict)
    elif level == 'ipxact':
        project_name = os.path.split(xml_name)[-1].split(".")[0]
        project_list = [project_name, '0x0', 32, {project_name}]
        block_map_dict, subblock_dict, subblock_dict_incd_reserved = gen_blockmap_subblock_dict_ipxact(root)
    else:
        project_list = gen_project_list(root)
        block_map_dict = gen_block_map_dict(root, project_list)
        subblock_dict, subblock_dict_incd_reserved = gen_subblock_dict(root, block_map_dict)
    ## sort
    block_offet_list = []
    block_offet_sort = []
    block_map_dict_sort = collections.OrderedDict()
    subblock_dict_sort = collections.OrderedDict()
    subblock_dict_incd_reserved_sort = collections.OrderedDict()
    for block_name in block_map_dict.keys():
        block_offet_list.append(int(re.sub('0x', '', block_map_dict[block_name][1]), 16))
        block_offet_list.sort()
    for block_offet in block_offet_list:
        for block_name in block_map_dict.keys():
            if hex(block_offet) == hex(eval((block_map_dict[block_name][1]).lower())):
                block_offet_sort.append(block_name)
                break
    for block_name in block_offet_sort:
    #for block_name in subblock_dict:
        block_map_dict_sort[block_name] = block_map_dict[block_name]
        subblock_dict_sort[block_name] = subblock_dict[block_name]
        subblock_dict_incd_reserved_sort[block_name] = subblock_dict_incd_reserved[block_name]
    return project_list, block_map_dict_sort, subblock_dict_sort, subblock_dict_incd_reserved_sort


# =========================generate subblock of ipxact begin>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

def gen_blockmap_subblock_dict_ipxact(root):
    block_map_dict = collections.OrderedDict()
    subblock_list = root.getElementsByTagName('spirit:addressBlock')
    # subblock_dict = {}
    subblock_dict = collections.OrderedDict()
    subblock_dict_incd_reserved = collections.OrderedDict()
    subblock_addr_dict = collections.OrderedDict()
    block_base_address = hex(0)
    block_offset = ''
    for subblock in subblock_list:
        subblock_name = subblock.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
        block_offset_name = subblock.getElementsByTagName('spirit:baseAddress')[0].childNodes[0].data.replace(' ', '')
        if type(block_offset_name) is str:
            parameters = root.getElementsByTagName('spirit:parameters')
            for parameter in parameters:
                parameter_name = parameter.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
                parameter_value = parameter.getElementsByTagName('spirit:value')[0].childNodes[0].data.replace(' ', '')
                if parameter_name == block_offset_name:
                    block_offset = (parameter_value.replace("'h", "0x")).lower()
        elif type(block_offset_name) is int:
            block_offset = (block_offset_name.replace("'h", "0x")).lower()
        block_data_width = int(subblock.getElementsByTagName('spirit:width')[0].childNodes[0].data.replace(' ', ''))
        block_size = subblock.getElementsByTagName('spirit:range')[0].childNodes[0].data.replace(' ', '')
        instance_number = 1
        block_description = 'ip-xact'
        block_map_dict[subblock_name] = (
            block_base_address, block_offset, block_data_width, block_size, block_description, instance_number,
            subblock_name)
        # subblock_dict = {}
        subblock_dict = collections.OrderedDict()
        subblock_dict_incd_reserved = collections.OrderedDict()
        for subblock in subblock_list:
            subblock_name = subblock.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
            print("aaaaaddddcc")
            #print(block_map_dict.keys())
            if subblock_name in block_map_dict.keys():
                print("caargaga")
                register_list = subblock.getElementsByTagName('spirit:register')
                subblock_dw = block_map_dict[subblock_name][2]
                pre_offset_step = math.ceil(subblock_dw / 8)
                reg_offset_step = pre_offset_step
                reg_offset = 0 - reg_offset_step
                subblock_reg_list = []
                subblock_reg_list_incd_reserved = []
                reg_names = set()
                reserved_addrs = []
                for register in register_list:
                    reg_name = register.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
                    if reg_name not in reg_names:
                        reg_names.add(reg_name)
                    else:
                        raise Exception("register duplicate declaration,subblock_name=【%s】,"
                                        "reg_name=【%s】" % (subblock_name, reg_name))
                    if register.getElementsByTagName('spirit:size'):
                        reg_width = int(
                            re.sub(r'\D', '', register.getElementsByTagName('spirit:size')[0].childNodes[0].data))
                        reg_offset_step = math.ceil(reg_width / 8)
                    else:
                        reg_width = subblock_dw
                    if register.getElementsByTagName('spirit:addressOffset'):
                        tmp_reg_offset = int(
                            re.sub("'h", '',
                                   register.getElementsByTagName('spirit:addressOffset')[0].childNodes[0].data), 16)
                        if reg_offset + reg_offset_step > tmp_reg_offset:
                            print('Error::::The start address of the reg has been used,block_name=【{}】,reg_name=【{}】,'
                                  'reg_offset=【{}】,used_reg_offset=【{}】'.format(
                                subblock_name, reg_name, hex(tmp_reg_offset), hex(reg_offset + reg_offset_step - 4)))
                        if tmp_reg_offset > reg_offset + reg_offset_step:
                            for i in range(0, (tmp_reg_offset - (reg_offset + reg_offset_step)) // 4):
                                reserved_addrs.append(reg_offset + reg_offset_step + i * 4)
                        if tmp_reg_offset % 4 != 0:
                            print('Error::::The address is set incorrectly,not a multiple of 4,block_name=【{}】,'
                                  'reg_name=【{}】,reg_offset=【{}】'.format(subblock_name, reg_name, hex(tmp_reg_offset)))
                        reg_offset = tmp_reg_offset
                    else:
                        reg_offset += reg_offset_step
                    print(reg_offset)
                    print("fafege")
                    print(type(block_size))
                    if "0x" in str(block_size):
                        block_size = int(block_size.split("0x")[-1],16)
                    print(block_size)
                    if int(reg_offset) > int(block_size):
                        print('Error::::The address is set incorrectly,register address overflow,block_name=【{}】,'
                              'reg_name=【{}】,reg_offset=【{}】,block_size=【{}】'.format(subblock_name, reg_name,
                                                                                     hex(reg_offset), hex(block_size)))
                    reg_type = 'register'
                    if register.getElementsByTagName('spirit:usageType'):
                        reg_type = register.getElementsByTagName('spirit:usageType')[0].childNodes[0].data.replace(' ',
                                                                                                                   '')
                    if register.getElementsByTagName('spirit:reg_depth'):
                        reg_depth = int(
                            re.sub("'h", '', register.getElementsByTagName('spirit:reg_depth')[0].childNodes[0].data),
                            16)
                        reg_offset_step = reg_depth
                    else:
                        reg_depth = 1
                        reg_offset_step = pre_offset_step
                    if register.getElementsByTagName('spirit:size'):
                        reg_width = int(
                            re.sub(r'\D', '', register.getElementsByTagName('spirit:size')[0].childNodes[0].data))
                        reg_offset_step = math.ceil(reg_width / 8)
                    else:
                        reg_width = subblock_dw
                        reg_offset_step = pre_offset_step
                    field_property_list = []
                    field_property_list_incd_reserved = []
                    used_field_offset = 0
                    field_names = set()
                    field_init_value = ''
                    for field in register.getElementsByTagName('spirit:field'):
                        field_name = field.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
                        if field_name not in field_names:
                            field_names.add(field_name)
                        else:
                            raise Exception("field duplicate declaration,subblock_name=【%s】,reg_name=【%s】,"
                                            "field_name=【%s】" % (subblock_name, reg_name, field_name))
                        field_offset = field.getElementsByTagName('spirit:bitOffset')[0].childNodes[0].data.replace(' ',
                                                                                                                    '')
                        field_width = field.getElementsByTagName('spirit:bitWidth')[0].childNodes[0].data.replace(' ',
                                                                                                                  '')
                        if field.getElementsByTagName('spirit:access'):
                            field_access_name = field.getElementsByTagName('spirit:access')[0].childNodes[0].data
                        else:
                            field_access_name = register.getElementsByTagName('spirit:access')[0].childNodes[0].data
                        # unify the name of field_access in ipxact and uvm
                        if field_access_name == 'read-only':
                            field_access = 'RO'
                        elif field_access_name == 'write-only':
                            field_access = 'WO'
                        elif field_access_name == 'read-write':
                            field_access = 'RW'
                        elif field_access_name == 'writeOnce':
                            field_access = 'WO1'
                        elif field_access_name == 'read-writeOnce':
                            field_access = 'W1'
                        else:
                            field_access = field_access_name
                        '''''''''''
                        #field_init_value is enumeratedValues-IDLE
                        if field.getElementsByTagName('spirit:enumeratedValues'):
                            for enumeratedValue in field.getElementsByTagName('spirit:enumeratedValues'):
                                enumeratedValue_name = enumeratedValue.getElementsByTagName('spirit:name')[0].childNodes[0].data
                                if enumeratedValue_name == 'IDLE':
                                    field_init_value = hex(int(enumeratedValue.getElementsByTagName('spirit:value')[0].childNodes[0].data.replace(
                                        ' ', '')))
                        else:
                            field_init_value = '0x0'
                        '''''''''''
                        # field_init_value is reset
                        if field.getElementsByTagName('spirit:resets'):
                            for reset in field.getElementsByTagName('spirit:resets'):
                                field_init_value = hex(int(
                                    reset.getElementsByTagName('spirit:value')[0].childNodes[0].data.replace("'h", ''),
                                    16))
                        else:
                            field_init_value = '0x0'
                        if field.getElementsByTagName('spirit:description'):
                            field_description = field.getElementsByTagName('spirit:description')[0].childNodes[0].data
                        else:
                            field_description = 'none'
                        if field_access not in ['RO', 'WO', 'RW', 'W1', 'WO1',
                                                'W1S', 'RC', 'W1C', 'WRC', 'RWHW' , 'RU']:
                            print(
                                'Error::::The field_access is not support and replace it with other types,block_name=【{}】,'
                                'reg_name=【{}】,field_name=【{}】,field_access=【{}】'.format(
                                    subblock_name, reg_name, field_name, field_access))
                        if int(int(int(field_offset) % 32) + int(field_width)) > 32:
                            print('Error::::Field domain crosses the boundary,block_name=【{}】,'
                                  'reg_name=【{}】,field_name=【{}】,field_offset=【{}】,field_width=【{}】'.format(
                                subblock_name, reg_name, field_name, field_offset, field_width))
                        if int(re.sub('0x', '', field_init_value), 16) >= 1 << int(field_width):
                            print('Error::::The field_init_value is set inappropriate,has overflowed,block_name=【{}】,'
                                  'reg_name=【{}】,field_name=【{}】,field_width=【{}】,field_init_value=【{}】'.format(
                                subblock_name, reg_name, field_name, field_width, field_init_value))
                        if int(field_offset) % 4 != 0:
                            print(
                                'Warning::::The field_offset is set inappropriate,not a multiple of 4,block_name=【{}】,'
                                'reg_name=【{}】,field_name=【{}】,field_offset=【{}】'.format(
                                    subblock_name, reg_name, field_name, field_offset))
                        if int(used_field_offset) > int(field_offset):
                            print('Error::::The start field_offset of the field has been used,block_name=【{}】,'
                                  'reg_name=【{}】,field_name=【{}】,field_offset=【{}】,used_field_offset=【{}】'.format(
                                subblock_name, reg_name, field_name, field_offset, used_field_offset))
                        if int(field_offset) > int(used_field_offset):
                            reserved_width = int(field_offset) - int(used_field_offset)
                            field_property_list_incd_reserved.append(
                                ('Reserved', used_field_offset, reserved_width, 'NA', "0x0",
                                 'reserved', ''))
                        used_field_offset = int(field_offset) + int(field_width)
                        if field.getElementsByTagName('spirit:field_hdl_path'):
                            field_hdl_path = field.getElementsByTagName('spirit:field_hdl_path')[0].childNodes[
                                0].data.replace(' ',
                                                '')
                        else:
                            if int(reg_width) > 32:
                                num32 = int(int(field_offset) / 32)
                                field_hdl_path = '''u_r_{}_{}_{}.u_f_{}'''.format(reg_name, int(num32 * 32),
                                                                                  int((num32 + 1) * 32 - 1),
                                                                                  field_name).replace(' ', '')
                            else:
                                field_hdl_path = 'u_r_{}.u_f_{}'.format(reg_name, field_name).replace(' ', '')
                        field_property_list.append(
                            (field_name, field_offset, field_width, field_access, field_init_value,
                             field_description, field_hdl_path))
                        field_property_list_incd_reserved.append(
                            (field_name, field_offset, field_width, field_access, field_init_value,
                             field_description, field_hdl_path))
                    if int(used_field_offset) % 32 != 0:
                        boundary_width = (int(int(used_field_offset) / 32) + 1) * 32
                        reserved_width = int(boundary_width) - int(used_field_offset)
                        field_property_list_incd_reserved.append(
                            ('Reserved', used_field_offset, reserved_width, 'NA', "0x0",
                             'reserved', ''))
                    subblock_reg_list.append(
                        (reg_name, hex(reg_offset), reg_type, reg_depth, reg_width, field_property_list, 1))
                    subblock_reg_list_incd_reserved.append(
                        (reg_name, hex(reg_offset), reg_type, reg_depth, reg_width, field_property_list_incd_reserved ,1))
                subblock_addr_list = [reg_offset, block_size, block_offset, block_base_address, reserved_addrs]
                subblock_addr_dict[subblock_name] = subblock_addr_list
                subblock_dict[subblock_name] = subblock_reg_list
                subblock_dict_incd_reserved[subblock_name] = subblock_reg_list_incd_reserved
            else:
                print("Error::::Sub block name Error,not belong sys_reg,please check the xml subblock_name=【{}】".format(
                    subblock_name))
            # sys.exit()
    # for key in subblock_dict.keys():
    #     print('2>>>>{}::::{}'.format(key, subblock_dict[key]))
    gen_block_internal_reserved_addr(subblock_addr_dict)
    return block_map_dict, subblock_dict, subblock_dict_incd_reserved


# =========================generate blockmap of ipxact begin>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

def gen_block_map_dict_ipxact(root, project_list):
    project_baddr = project_list[1]
    project_dw = project_list[2]
    block_map_list = root.getElementsByTagName('spirit:addressBlock')
    # block_map_dict = {}
    block_names = set()
    block_map_dict = collections.OrderedDict()
    used_addr_offset = 0
    for block in block_map_list:
        block_name = block.getElementsByTagName('spirit:name')[0].childNodes[0].data.replace(' ', '')
        if block_name not in block_names:
            block_names.add(block_name)
        else:
            raise Exception("addressBlock duplicate declaration,addressBlock_name=【%s】" % block_name)
        block_base_address = project_baddr
        block_offset = (block.getElementsByTagName('spirit:baseAddress')[0].childNodes[0].data.replace(' ', '')).lower()
        block_data_width = block.getElementsByTagName('spirit:width')[0].childNodes[0].data.replace(' ', '')
        block_size = block.getElementsByTagName('spirit:range')[0].childNodes[0].data.replace(' ', '')
        if project_dw != block_data_width:
            print('Warning::::the project width({}bits) != the {} width({}bits)'.format(project_dw, block_name,
                                                                                        block_data_width))
        if int(re.sub("'h", '', block_offset), 16) % 256 != 0:
            print('Error::::The block_offset is set incorrectly,not a multiple of 256,block_name=【{}】,'
                  'block_offset=【{}】'.format(block_name, block_offset))
        if int(re.sub("'h", '', block_size), 10) % 256 != 0:
            print('Error::::The block_size is set incorrectly,not a multiple of 256,block_name=【{}】,'
                  'block_size=【{}】'.format(block_name, block_size))
        if used_addr_offset > int(re.sub("'h", '', block_offset), 16):
            print('Error::::The start address of the block has been used,block_name=【{}】,block_offset=【{}】,'
                  'used_addr_offset=【{}】'.format(block_name, block_offset, hex(used_addr_offset)))
        used_addr_offset = int(re.sub("'h", '', block_offset), 16) + int(re.sub("'h", '', block_size), 10)
        block_map_dict[block_name] = (block_base_address, block_offset, block_data_width, block_size)
    # print('1>>>>{}'.format(block_map_dict))
    return block_map_dict


# =========================generate html begin>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

def gen_title_context(title_dict):
    title_context = '\t\t\t<tr>\n'
    for key in title_dict.keys():
        title_context += '\t\t\t\t<th{}>{}</th>\n'.format(title_dict[key], key)
    title_context += '\t\t\t</tr>'
    return title_context


def gen_table_context(context_list):
    table_context = ''
    for line in context_list:
        table_context += '\t\t\t<tr>\n'
        for col in line:
            # table_context += '\t\t\t\t<th>{}</th>\n'.format(col)
            table_context += '\t\t\t\t<td>{}</td>\n'.format(col)
        table_context += '\t\t\t</tr>\n'
    return table_context


def gen_table(title_context, table_context):
    context = '''
        <table style="border-collapse:collapse;" border="1" cellspacing="0" bgcolor="">
{_title_context}
{_table_context}
        </table>
'''.format(_title_context=title_context, _table_context=table_context)
    return context


def gen_top_table(block_map_dict):
    title_dict = {'Base Address': ' bgcolor="#CDCDCD"', 'Offset': ' bgcolor="#CDCDCD"',
                  'Block Name': ' bgcolor="#CDCDCD"', 'block_size': ' bgcolor="#CDCDCD"',
                  ' Remark ': ' bgcolor="#CDCDCD"'}
    title_context = gen_title_context(title_dict)
    context_list = []
    for key in block_map_dict.keys():
        block_name = '<a href="{}#lnk_{}">{}</a>'.format(key + '.html', key.upper(), key)
        context_list.append((block_map_dict[key][0], block_map_dict[key][1], block_name, block_map_dict[key][3],
                             block_map_dict[key][4]))
    table_context = gen_table_context(context_list)
    context = gen_table(title_context, table_context)
    return context


def gen_subblock_table(subblock_name, subblock_dw, subblock_list):
    title_dict = {'Block Name:{}<a name="lnk_{}"></a>'.format(subblock_name,
                                                              subblock_name.upper()): ' bgcolor="#CDCDCD" colspan="3"'}
    title_context = gen_title_context(title_dict)
    title_dict = {'Offset': ' bgcolor="#CDCDCD"', 'Register Name': ' bgcolor="#CDCDCD"',
                  'Default Value': ' bgcolor="#CDCDCD"'}
    title_context += gen_title_context(title_dict)
    context_list = []
    for i in range(len(subblock_list)):
        if subblock_list[i][4] > subblock_dw:
            reg_name = '<a href="#lnk_{}[{}:0]">{}[{}:0]</a>'.format(subblock_list[i][0].upper(),
                                                                     subblock_list[i][4] - 1, subblock_list[i][0],
                                                                     subblock_list[i][4] - 1)
        else:
            reg_name = '<a href="#lnk_{}">{}</a>'.format(subblock_list[i][0].upper(), subblock_list[i][0])
        if subblock_list[i][3] > 1:
            reg_offset = '{}~{}'.format(subblock_list[i][1], hex(
                int(subblock_list[i][1], 16) + subblock_list[i][3] - math.ceil(subblock_dw / 8)))
        else:
            reg_offset = subblock_list[i][1]
        default_value = 0
        for field in subblock_list[i][5]:
            default_value += int(re.sub('0x', '', field[4]), 16) * (2 ** int(field[1]))
        default_value = hex(default_value)
        context_list.append((reg_offset, reg_name, default_value))
    table_context = gen_table_context(context_list)
    context = gen_table(title_context, table_context)
    return context


def gen_register_table(subblock, block_base_address, reg_name, reg_offset, reg_list):
    title_dict = {
        'Register Name: {}<a name="lnk_{}"></a>'.format(reg_name, reg_name.upper()): ' bgcolor="#E6E6FA" colspan="5"'}
    title_context = gen_title_context(title_dict)
    title_dict = {'Register Offset Address: {}'.format(reg_offset): ' bgcolor="#CDCDCD" colspan="5"'}
    title_context += gen_title_context(title_dict)
    title_dict = {'Owning Block: {} | Block Base Address: {}'.format(subblock,
                                                                     block_base_address): ' bgcolor="#CDCDCD" colspan="5"'}
    title_context += gen_title_context(title_dict)
    title_dict = {'Field': ' bgcolor="#CDCDCD" width="240"', 'Bit': ' bgcolor="#CDCDCD" width="60"',
                  'Reset Value': ' bgcolor="#CDCDCD" width="80"', 'RW': ' bgcolor="#CDCDCD" width="40"',
                  'Description': ' bgcolor="#CDCDCD" width="800"'}
    title_context += gen_title_context(title_dict)
    context_list = []
    for field in reg_list:
        field_name = field[0]
        field_bit = '{}:{}'.format(int(field[1]) + int(field[2]) - 1, int(field[1]))
        field_init_value = field[4]
        field_rw = field[3]
        field_description = '<p align="left">{}</p>'.format(field[5].replace(r'\n', '<Br>'))
        context_list.append((field_name, field_bit, field_init_value, field_rw, field_description))
    table_context = gen_table_context(context_list)
    context = gen_table(title_context, table_context)
    return context


def gen_html(project_name, body_context):
    file_path = './html'
    file_name = '{}.html'.format(project_name)
    context = '''<!DOCTYPE html>
<html>
    <head>
        <title></title>
        <meta charset="utf-8">
    </head>
    <body>
{_body_context}
    </body>
</html>
'''.format(_body_context=body_context)
    gen_file(file_path, file_name, context)


def gen_menu(reg, project_name):
    # global iframe, menu_mess
    menu_mess_str = ''

    for key in reg.keys():
        iframe = """<iframe id="main" src="{0}" frameborder="0"></iframe>""".format(reg[key]["file"])
        break

    for key in reg.keys():
        li_mess_str = ''
        if "sub_reg" in reg[key].keys():
            for sub_key, sub_value in reg[key]["sub_reg"].items():
                li_mess = """<li onclick="switchPage(this, '{0}#{1}')">{2}</li>""".format(reg[key]["file"],
                                                                                          "lnk_" + sub_value.upper(),
                                                                                          sub_key)
                li_mess_str += li_mess

        menu_mess = """<div class="menu-item" onclick="switchPage(this, '{0}')">
        <span>{1}</span>
        <span onclick="fold('id_ol_{1}', this)" class="fold"></span>
        </div>
        <ol id="id_ol_{1}">
        {2}
        </ol>""".format(reg[key]["file"], reg[key]["file"].split(".")[0], li_mess_str)

        menu_mess_str += menu_mess
    script = """<script>
  function switchPage(obj, url) {
    for (let i = 0; i < document.getElementsByClassName('menu-item').length ; i++) {
      let item = document.getElementsByClassName('menu-item')[i]
      item.style.background = '#4d4d4d'
      item.style.color = '#d9d9d9'
    }
    for (let i = 0; i < document.getElementsByTagName('li').length ; i++) {
      let item = document.getElementsByTagName('li')[i]
      item.style.background = '#4d4d4d'
      item.style.color = '#d9d9d9'
    }
    obj.style.background = '#ffffff'
    obj.style.color = '#000'
    document.getElementById('main').src = url
    window.event.stopPropagation();
  }
  function fold(id, spanElement) {
	var ele = document.getElementById(id);
	if (!ele) {
	    return;
	}
	var display = ele && ele.style && ele.style.display;
	ele.style.display = display !== 'none' ? 'none' : 'block';
	spanElement.className = display !== 'none' ? 'unfold' : 'fold';
  }
</script>"""

    style = """  <style>
    html,body{
      width: 100%;
      height: 100%;
    }
    *{
      margin: 0px;
      padding: 0px;
    }
    ol, li{
       /*list-style: none;*/
    }
    li{
      margin-left: 38px;
      cursor: pointer;
      height: 20px;
      line-height: 14px;
      font-size: 14px;
      padding: 2px;
    }
    .container{
      position: relative;
      width: 100%;
      height: 100%;
    }
    .menu{
      width: 360px;
      height: 100%;
      box-sizing: border-box;
      padding: 20px;
      background-color: #4d4d4d;
      color: #d9d9d9;
      overflow: auto
    }
    .menu-item{
      margin-bottom: 6px;
      padding: 2px;
      cursor: pointer;
    }
    #main{
      position: absolute;
      top: 0;
      left: 365px;
      padding: 20px;
      width: 1100px;
      height: 100%;
      box-sizing: border-box;
      border: 1px solid #ccc;
      border-radius: 20px;
    }
            
    .fold {
	  background: url('fold.svg') center center/100% 100% no-repeat;
	}
	.unfold {
	  background: url('unfold.svg') center center/100% 100% no-repeat;
	}
    .fold, .unfold {
	  display:inline-block;
	  margin-left: 8px;
	  height: 16px;
	  width: 16px;
	}
	
  </style>
"""

    mess = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>菜单</title>
  {style}
</head>
<body>
  <div class="container">
    <div class="menu">
      {menu_mess}
    </div>
    {iframe}
  </div>
{script}
</body>
</html>
""".format(style=style, menu_mess=menu_mess_str, iframe=iframe, script=script)
    pathname = './html/' + project_name + '_menu.html'
    # with open("./html/menu.html", "w", encoding="utf-8") as f:
    with open(pathname, "w", encoding="utf-8") as f:
        f.write(mess)


def extract_all_id(id_set):
    trunk_list = []
    len_id_min = 1000
    branch_set = set()
    for un in id_set:
        un_list = un.split('.')
        if len_id_min > len(un_list):
            len_id_min = len(un_list)
        for un_index, un_value in enumerate(un_list):
            if not un_index < len(trunk_list):
                trunk_list.append(branch_set)
            tmp_branch_set = set(trunk_list[un_index])
            if un_value not in tmp_branch_set:
                tmp_branch_set.add(un_value)
            trunk_list[un_index] = tmp_branch_set
    return trunk_list


def gen_subblock_html(project_baddr, block_map_dict, subblock_dict):
    blank_line = '\t\t<p> </p>'
    for subblock in block_map_dict.keys():
        if subblock in subblock_dict.keys():
            sub_reg_dict = {}
            block_base_address = hex(int(block_map_dict[subblock][1], 16) + int(project_baddr, 16))
            sub_body_context = '\t\t<p>BLOCK_BASE_ADDRESS: {}</p>'.format(block_base_address)
            subblock_list = subblock_dict[subblock]
            subblock_dw = block_map_dict[subblock][2]
            sub_body_context += gen_subblock_table(subblock, subblock_dw, subblock_list)
            sub_body_context += blank_line
            reg_dict = {}
            for i in range(len(subblock_list)):
                if subblock_list[i][4] > subblock_dw:
                    reg_name = '{}[{}:0]'.format(subblock_list[i][0], subblock_list[i][4] - 1)
                    reg_dict[reg_name] = reg_name
                else:
                    reg_name = subblock_list[i][0]
                    reg_dict[reg_name] = reg_name
                if subblock_list[i][3] > 1:
                    reg_offset = '{}~{}'.format(subblock_list[i][1], hex(
                        int(subblock_list[i][1], 16) + subblock_list[i][3] - math.ceil(subblock_dw / 8)))
                else:
                    reg_offset = subblock_list[i][1]
                sub_body_context += gen_register_table(subblock, block_base_address, reg_name, reg_offset,
                                                       subblock_list[i][5])
                sub_body_context += blank_line
            sub_body_context += blank_line
            gen_html(subblock, sub_body_context)


def gen_menu_bracket(id_set, trunk_list):
    used_id = set()
    bracket_context_dict = {}
    for un in id_set:
        un_list = un.split('.')
        temp_id = un_list[0]
        for i in range(len(un_list)):
            if not temp_id in used_id:
                temp_id_header = '''
                    <div class="menu-sub_{_i}" onclick="switchPage(this, '{_id_name}_sys_reg.html')">
                        <span>{_id_name}_reg</span>
                        <span onclick="fold('id_{_id_name}_subsystem', this)" class="fold"></span>
                    </div> '''.format(_i=i, _id_name=temp_id)
                temp_id_body = ''''''
                bracket_context_dict[temp_id] = [temp_id_header, temp_id_body]
                used_id.add(temp_id)
            if i != len(un_list) - 1:
                temp_id += '.' + un_list[i + 1]
    return bracket_context_dict


def gen_menu_endpoint(block_map_dict, subblock_dict):
    subblock_menu_dict = {}
    for subblock in block_map_dict.keys():
        if subblock in subblock_dict.keys():
            sub_reg_dict = {}
            subblock_list = subblock_dict[subblock]
            subblock_dw = block_map_dict[subblock][2]
            reg_dict = {}
            for i in range(len(subblock_list)):
                if subblock_list[i][4] > subblock_dw:
                    reg_name = '{}[{}:0]'.format(subblock_list[i][0], subblock_list[i][4] - 1)
                    reg_dict[reg_name] = reg_name
                else:
                    reg_name = subblock_list[i][0]
                    reg_dict[reg_name] = reg_name
            sub_reg_dict['file'] = subblock + '.html'
            sub_reg_dict['sub_reg'] = reg_dict
            sub_reg_dict['id'] = block_map_dict[subblock][6]
            subblock_menu_dict[subblock] = gen_oneblock_menu_list(sub_reg_dict)
    return subblock_menu_dict


def gen_oneblock_menu_list(reg):
    li_mess_str = ''
    if "sub_reg" in reg.keys():
        for sub_key, sub_value in reg["sub_reg"].items():
            li_mess = """<li onclick="switchPage(this, '{0}#{1}')">{2}</li>""".format(reg["file"],
                                                                                      "lnk_" + sub_value.upper(),
                                                                                      sub_key)
            li_mess_str += li_mess
    menu_mess = """<div class="menu-item_{0}" onclick="switchPage(this, '{1}')">
    <span>{2}</span>
    <span onclick="fold('id_ol_{2}', this)" class="fold"></span>
    </div>
    <ol id="id_ol_{2}" class="item_attribute_{3}">
    {4}
    </ol>""".format(len(reg['id'].split('.')), reg["file"], reg["file"].split(".")[0], len(reg['id'].split('.')) - 1,
                    li_mess_str)
    return menu_mess


def gen_sys_reg(project_name, block_map_dict):
    # blank_line = '\t\t<p><br/></p>'
    blank_line = '\t\t<p> </p>'
    asic_body_context = '\t\t<p>{} Register User Manual</p>'.format(project_name)
    asic_body_context += gen_top_table(block_map_dict)
    asic_body_context += blank_line
    # gen_html(project_name, asic_body_context)
    gen_html(project_name + '_sys_reg', asic_body_context)


def gen_menu_html(my_menu, trunk_list):
    head_menu = '''<head>
    <meta charset="UTF-8">
    <title>菜单</title>
    <style>
        html, body {
            width: 100%;
            height: 100%;
        }'''
    for i in range(len(trunk_list) + 1):
        head_menu += '''
        .menu-sub_%d {
            margin-left: %dpx;
            margin-bottom: 8px;
            padding: 2px;
            cursor: pointer;
            line-height:140%%;
        }''' % (i, i * 18)
        head_menu += '''
        .sub_attribute_%d {
            display: none;
            margin-left: %dpx;
            margin-bottom: 8px;
            padding: 2px;
            cursor: pointer;   
            line-height:140%%;         
        }
        ''' % (i, i * 6)
        head_menu += '''
        .menu-item_%d {
            margin-left: %dpx;
            margin-bottom: 6px;
            padding: 2px;
            cursor: pointer;
            line-height:140%%;
        }
        ''' % (i, i * 18)
        head_menu += '''
        .item_attribute_%d {
            display: none;
            margin-left: %dpx;
            cursor: pointer;
            /*height: 20px;*/
            line-height: 14px;
            /*font-size: 14px;*/
            padding: 2px;       
        }
        ''' % (i, i * 18 + 14)
    head_menu += '''
        * {
            margin: 0px;
            padding: 0px;
        }

        ol, li {
            /*list-style: none;*/
        }

        li {
            margin-left: 36px;
            cursor: pointer;
            height: 20px;
            line-height: 14px;
            font-size: 14px;
            padding: 2px;
        }

        .container {
            position: relative;
            width: 100%;
            height: 100%;
        }

        .menu {
            width: 360px;
            height: 100%;
            box-sizing: border-box;
            padding: 20px;
            background-color: #4d4d4d;
            color: #d9d9d9;
            overflow: auto;
            line-height:200%
        }

        .menu-item {
            margin-left: 18px;
            margin-bottom: 6px;
            padding: 2px;
            cursor: pointer;
            line-height:140%
        }

        .menu-sub {
            margin-left: 6px;
            margin-bottom: 8px;
            padding: 2px;
            cursor: pointer;
            line-height:140%
        }

        #main {
            position: absolute;
            top: 0;
            left: 365px;
            padding: 20px;
            width: 1100px;
            height: 100%;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 20px;
        }

        .fold {
            background: url('fold.svg') center center/100% 100% no-repeat;
        }

        .unfold {
            background: url('unfold.svg') center center/100% 100% no-repeat;
        }

        .fold, .unfold {
            display: inline-block;
            margin-left: 8px;
            height: 16px;
            width: 16px;
        }

        .sub_attribute {
            display: none;
        }

    </style>
</head>'''
    top_menu = '''<!DOCTYPE html>
<html lang="en">''' + head_menu + '''<body>''' + my_menu + '''<script>
    function switchPage(obj, url) {
        for (let i = 0; i < document.getElementsByClassName('menu-item').length; i++) {
            let item = document.getElementsByClassName('menu-item')[i]
            item.style.background = '#4d4d4d'
            item.style.color = '#d9d9d9'
        }
        for (let i = 0; i < document.getElementsByClassName('menu-sub').length; i++) {
            let item = document.getElementsByClassName('menu-sub')[i]
            item.style.background = '#4d4d4d'
            item.style.color = '#d9d9d9'
        }
        for (let i = 0; i < document.getElementsByTagName('li').length; i++) {
            let item = document.getElementsByTagName('li')[i]
            item.style.background = '#4d4d4d'
            item.style.color = '#d9d9d9'
        }
        obj.style.background = '#ffffff'
        obj.style.color = '#000'
        document.getElementById('main').src = url
        window.event.stopPropagation();
    }

    function fold(id, spanElement) {
        var ele = document.getElementById(id);
        if (!ele) {
            return;
        }
        var display = ele && ele.style && ele.style.display;
        ele.style.display = display !== 'none' ? 'none' : 'block';
        spanElement.className = display !== 'none' ? 'unfold' : 'fold';
    }
</script>
</body>''' + '''</html>'''
    pathname = './html/' + tmp_project_list[0] + '_menu.html'
    # with open("./html/menu.html", "w", encoding="utf-8") as f:
    with open(pathname, "w", encoding="utf-8") as f:
        f.write(top_menu)


def xml2html2(tmp_project_list, block_map_dict, subblock_dict):
    id_set = tmp_project_list[3]
    trunk_list = extract_all_id(id_set)
    print('id_set=', id_set)
    print('trunk_list=', trunk_list)
    gen_subblock_html(tmp_project_list[1], block_map_dict, subblock_dict)
    for un in id_set:
        tmp_block_map_dict = {}
        for subblock in block_map_dict.keys():
            if un in block_map_dict[subblock][6]:
                tmp_block_map_dict.update({subblock: block_map_dict[subblock]})
        gen_sys_reg(un, tmp_block_map_dict)
    bracket_menu_dict = gen_menu_bracket(id_set, trunk_list)
    subblock_menu_dict = gen_menu_endpoint(block_map_dict, subblock_dict)
    top_menu = ''
    for subblock in block_map_dict.keys():
        temp_id = block_map_dict[subblock][6]
        bracket_menu_dict[temp_id][1] += subblock_menu_dict[subblock]
    for i in range(len(trunk_list)):
        ii = len(trunk_list) - i
        if ii > 1:
            for un in id_set:
                if ii == len(un.split('.')):
                    print('un=', un)
                    un_father = un.rsplit(".", 1)[0]
                    bracket_menu_dict[un][
                        1] = '''<div id="id_{_id_name}_subsystem" class="sub_attribute{_ii}">'''.format(
                        _id_name=un, _ii=ii - 1) + bracket_menu_dict[un][1] + '</div>'
                    bracket_menu_dict[un_father][1] += bracket_menu_dict[un][0]
                    bracket_menu_dict[un_father][1] += bracket_menu_dict[un][1]
        else:
            id_root = list(id_set)[0].split('.')[0]
            top_menu = '''<span>{_id_name}_reg</span>'''.format(_id_name=id_root)
            top_menu += bracket_menu_dict[id_root][1]

    top_menu = '''<div class="menu">''' + top_menu + '''</div>'''
    top_menu += '''<iframe id="main" src="{_id_name}_sys_reg.html" frameborder="0"></iframe>'''.format(
        _id_name=list(trunk_list[0])[0])
    top_menu = '''<div class="container">''' + top_menu + '''</div>'''
    gen_menu_html(top_menu, trunk_list)


def xml2html(project_name, project_baddr, block_map_dict, subblock_dict):
    dirs = './html/'
    if not os.path.exists(dirs):
        os.makedirs(dirs)
    filename = './html/fold.svg'
    if not os.path.exists(filename):
        # os.system("cp -rf ./icon/fold.svg ./html/")
        try:
            shutil.copy("./icon/fold.svg", "./html/")
        except Exception as A:
            print("icon copy failure")
    filename = './html/unfold.svg'
    if not os.path.exists(filename):
        # os.system("cp -rf ./icon/unfold.svg ./html/")
        try:
            shutil.copy("./icon/unfold.svg", "./html/")
        except Exception as A:
            print("icon copy failure")
    # blank_line = '\t\t<p><br/></p>'
    blank_line = '\t\t<p> </p>'
    asic_body_context = '\t\t<p>{} Register User Manual</p>'.format(project_name)
    asic_body_context += gen_top_table(block_map_dict)
    asic_body_context += blank_line
    # gen_html(project_name, asic_body_context)
    gen_html(project_name + '_sys_reg', asic_body_context)
    # asic_reg_dict = {}
    asic_reg_dict = collections.OrderedDict()
    hip_reg_dict = {}
    hip_reg_dict['file'] = project_name + '_sys_reg' + '.html'
    asic_reg_dict[project_name] = hip_reg_dict
    # print(">>>2021.2.8------{}".format(asic_reg_dict))
    for subblock in block_map_dict.keys():
        if subblock in subblock_dict.keys():
            sub_reg_dict = {}
            block_base_address = hex(int(block_map_dict[subblock][1], 16) + int(project_baddr, 16))
            #block_base_address = int(project_baddr, 16)
            sub_body_context = '\t\t<p>BLOCK_BASE_ADDRESS: {}</p>'.format(block_base_address)
            subblock_list = subblock_dict[subblock]
            subblock_dw = block_map_dict[subblock][2]
            sub_body_context += gen_subblock_table(subblock, subblock_dw, subblock_list)
            sub_body_context += blank_line
            reg_dict = {}
            for i in range(len(subblock_list)):
                if subblock_list[i][4] > subblock_dw:
                    reg_name = '{}[{}:0]'.format(subblock_list[i][0], subblock_list[i][4] - 1)
                    reg_dict[reg_name] = reg_name
                else:
                    reg_name = subblock_list[i][0]
                    reg_dict[reg_name] = reg_name
                if subblock_list[i][3] > 1:
                    reg_offset = '{}~{}'.format(subblock_list[i][1], hex(
                        int(subblock_list[i][1], 16) + subblock_list[i][3] - math.ceil(subblock_dw / 8)))
                else:
                    reg_offset = subblock_list[i][1]
                sub_body_context += gen_register_table(subblock, block_base_address, reg_name, reg_offset,
                                                       subblock_list[i][5])
                sub_body_context += blank_line
            sub_body_context += blank_line
            gen_html(subblock, sub_body_context)
            sub_reg_dict['file'] = subblock + '.html'
            sub_reg_dict['sub_reg'] = reg_dict
            asic_reg_dict[subblock] = sub_reg_dict
            # print(">>>2021.2.8------{}".format(asic_reg_dict))
    gen_menu(asic_reg_dict, project_name)


# =============================generate html end  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# ================generate sv(register model) begin>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def gen_reg_model_title(blk_name):
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    author = 'Heterogeneous Computing Group'
    title = '''//=========================================================
//File name    : {_blk_name}_reg_model.sv
//Author       : {_author}
//Module name  : {_blk_name}_reg_model
//Discribution : {_blk_name}_reg_model : register model
//Date         : {_curr_time}
//=========================================================
`ifndef {_Ublk_name}_REG_MODEL__SV
`define {_Ublk_name}_REG_MODEL__SV
'''.format(_blk_name=blk_name, _author=author, _curr_time=curr_time, _Ublk_name=blk_name.upper())
    return title


def gen_reg_bkdr_intf_title(blk_name):
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    author = 'Heterogeneous Computing Group'
    title = '''//=========================================================
//File name    : {_blk_name}_reg_bkdr_intf.sv
//Author       : {_author}
//Module name  : {_blk_name}_reg_bkdr_intf
//Discribution : {_blk_name}_reg_bkdr_intf : register backdoor interface
//Date         : {_curr_time}
//=========================================================
`ifndef {_Ublk_name}_REG_BKDR_INTF__SV
`define {_Ublk_name}_REG_BKDR_INTF__SV
//`ifndef UVM_RAL_BACKDOOR_OFF
'''.format(_blk_name=blk_name, _author=author, _curr_time=curr_time, _Ublk_name=blk_name.upper())
    return title


def gen_mem_model_class(subblock_name, mem_name, mem_dw, mem_depth):
    mem_class = '''
class mem_{_bn}_{_mn} extends uvm_mem;
    function new(string name="mem_{_bn}_{_mn}");
        super.new(name,{_mdp},{_mdw});
    endfunction

    `uvm_object_utils(mem_{_bn}_{_mn})
endclass
'''.format(_bn=subblock_name, _mn=mem_name, _mdp=mem_depth, _mdw=mem_dw)
    return mem_class


def gen_reg_model_backdoor_class(subblock_name, reg_name, reg_type, reg_list):
    wr_connect, rd_connect = '\n', '\n'
    if reg_type == 'memory':
        wr_connect = '        //`{_Usbn}_PATH.{_sbn}.u_{_rn} = rw.value[0];\n'.format(_Usbn=subblock_name.upper(),
                                                                                      _sbn=subblock_name, _rn=reg_name)
        rd_connect = '        //rw.value[0] = `{_Usbn}_PATH.{_sbn}.u_{_rn};\n'.format(_Usbn=subblock_name.upper(),
                                                                                      _sbn=subblock_name, _rn=reg_name)
    else:
        for field in reg_list:
            f_lsb = int(field[1])
            f_msb = int(field[2]) + int(field[1]) - 1
            f_path = field[6]
            f_rw = field[3]
            if f_rw not in ['RO', 'RC']:
                wr_connect += '        `{_Usbn}_PATH.{_fp}.field = rw.value[0][{_msb}:{_lsb}];\n'.format(
                    _Usbn=subblock_name.upper(), _fp=f_path, _msb=f_msb, _lsb=f_lsb)
            rd_connect += '        rw.value[0][{_msb}:{_lsb}] = `{_Usbn}_PATH.{_fp}.field;\n'.format(
                _Usbn=subblock_name.upper(), _fp=f_path, _msb=f_msb, _lsb=f_lsb)
    reg_class = '''
class reg_{_bn}_{_rn}_bkdr extends uvm_reg_backdoor;

    task write(uvm_reg_item rw);
        do_pre_write(rw);
{_wc}
        rw.status = UVM_IS_OK;
        do_post_write(rw);
    endtask

    task read(uvm_reg_item rw);
        do_pre_read(rw);
{_rc}
        rw.status = UVM_IS_OK;
        do_post_read(rw);
    endtask

     `uvm_object_utils(reg_{_bn}_{_rn}_bkdr)
    function new(string name="reg_{_bn}_{_rn}_bkdr");
        super.new(name);
    endfunction

endclass
'''.format(_bn=subblock_name, _rn=reg_name, _wc=wr_connect, _rc=rd_connect)
    return reg_class


def gen_reg_model_backdoor_class2(subblock_name, reg_name, reg_type, reg_list):
    wr_connect, rd_connect = '\n', '\n'
    if reg_type == 'memory':
        wr_connect = '        //`{_Usbn}_PATH.{_sbn}.u_{_rn} = rw.value[0];\n'.format(_Usbn=subblock_name.upper(),
                                                                                      _sbn=subblock_name, _rn=reg_name)
        rd_connect = '        //rw.value[0] = `{_Usbn}_PATH.{_sbn}.u_{_rn};\n'.format(_Usbn=subblock_name.upper(),
                                                                                      _sbn=subblock_name, _rn=reg_name)
    else:
        # for field in reg_list:
        #     f_lsb = int(field[1])
        #     f_msb = int(field[2]) + int(field[1]) - 1
        #     f_path = field[6]
        #     f_rw = field[3]
        #     if f_rw not in ['RO', 'RC']:
        wr_connect += '         bkdr_if.{_bn}_{_rn}_write(rw);\n'.format(_bn=subblock_name, _rn=reg_name)
        rd_connect += '         bkdr_if.{_bn}_{_rn}_read(rw);\n'.format(_bn=subblock_name, _rn=reg_name)
    reg_class = '''
class reg_{_bn}_{_rn}_bkdr extends uvm_reg_backdoor;
    virtual {_bn}_reg_bkdr_intf bkdr_if;

    task write(uvm_reg_item rw);
        do_pre_write(rw);
{_wc}
        rw.status = UVM_IS_OK;
        do_post_write(rw);
    endtask

    task read(uvm_reg_item rw);
        do_pre_read(rw);
{_rc}
        rw.status = UVM_IS_OK;
        do_post_read(rw);
    endtask

     `uvm_object_utils(reg_{_bn}_{_rn}_bkdr)
    function new(string name="reg_{_bn}_{_rn}_bkdr");
        super.new(name);
    endfunction

endclass
'''.format(_bn=subblock_name, _rn=reg_name, _wc=wr_connect, _rc=rd_connect)
    return reg_class


def gen_reg_backdoor_interface(subblock_name, reg_name, reg_type, reg_list):
    wr_connect, rd_connect = '\n', '\n'
    if reg_type == 'memory':
        wr_connect = '        //`{_Usbn}_PATH.{_sbn}.u_{_rn} = rw.value[0];\n'.format(_Usbn=subblock_name.upper(),
                                                                                      _sbn=subblock_name, _rn=reg_name)
        rd_connect = '        //rw.value[0] = `{_Usbn}_PATH.{_sbn}.u_{_rn};\n'.format(_Usbn=subblock_name.upper(),
                                                                                      _sbn=subblock_name, _rn=reg_name)
    else:
        for field in reg_list:
            f_lsb = int(field[1])
            f_msb = int(field[2]) + int(field[1]) - 1
            f_path = field[6]
            f_rw = field[3]
            if f_rw not in ['RO', 'RC']:
                wr_connect += '        `{_Usbn}_PATH.{_fp}.field = rw.value[0][{_msb}:{_lsb}];\n'.format(
                    _Usbn=subblock_name.upper(), _fp=f_path, _msb=f_msb, _lsb=f_lsb)
            rd_connect += '        rw.value[0][{_msb}:{_lsb}] = `{_Usbn}_PATH.{_fp}.field;\n'.format(
                _Usbn=subblock_name.upper(), _fp=f_path, _msb=f_msb, _lsb=f_lsb)
    reg_class = '''

    function {_bn}_{_rn}_write(uvm_reg_item rw);
{_wc}
    endfunction

    function {_bn}_{_rn}_read(uvm_reg_item rw);
{_rc}
    endfunction


'''.format(_bn=subblock_name, _rn=reg_name, _wc=wr_connect, _rc=rd_connect)
    return reg_class


def gen_reg_backdoor_interface2(subblock_name, reg_name, reg_type, reg_list):
    wr_connect, rd_connect = '\n', '\n'
    if reg_type == 'memory':
        wr_connect = '        //`{_Usbn}_PATH.{_sbn}.u_{_rn} = rw.value[0];\n'.format(_Usbn=subblock_name.upper(),
                                                                                      _sbn=subblock_name, _rn=reg_name)
        rd_connect = '        //rw.value[0] = `{_Usbn}_PATH.{_sbn}.u_{_rn};\n'.format(_Usbn=subblock_name.upper(),
                                                                                      _sbn=subblock_name, _rn=reg_name)
    else:
        for field in reg_list:
            f_lsb = int(field[1])
            f_msb = int(field[2]) + int(field[1]) - 1
            f_path = field[6]
            f_rw = field[3]
            if f_rw not in ['RO', 'RC']:
                wr_connect += '        {_fp}.field = rw.value[0][{_msb}:{_lsb}];\n'.format(
                    _Usbn=subblock_name.upper(), _fp=f_path, _msb=f_msb, _lsb=f_lsb)
            rd_connect += '        rw.value[0][{_msb}:{_lsb}] = {_fp}.field;\n'.format(
                _Usbn=subblock_name.upper(), _fp=f_path, _msb=f_msb, _lsb=f_lsb)

    reg_class = '''

    function {_bn}_{_rn}_write(uvm_reg_item rw);
{_wc}
    endfunction

    function {_bn}_{_rn}_read(uvm_reg_item rw);
{_rc}
    endfunction


'''.format(_bn=subblock_name, _rn=reg_name, _wc=wr_connect, _rc=rd_connect)
    return reg_class


def gen_reg_model_class(subblock_name, reg_name, reg_dw, reg_list):
    f_declare = ''
    f_build = ''
    for field in reg_list:
        f_name = field[0]
        f_offset = int(field[1])
        f_width = int(field[2])
        f_init = field[4].replace("0x", "'h")
        f_rw = field[3]
        f_declare += "    rand uvm_reg_field {};\n".format(f_name.ljust(20))
        if '-volatile' in sys.argv:
            f_volatile = 1
            if f_rw in ['RW', 'WO']:
                f_volatile = 0
        else:
            f_volatile = 0
        if f_rw == 'RWHW':
            f_rw = 'RW'
        if f_rw == 'RU':
            f_rw = 'RO'
        f_build += '''
        {_fn} = uvm_reg_field::type_id::create("{_fn}");
        // parameter: parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
        {_fn}.configure(this,{_fw},{_fo},"{_frw}",{_f_volatile},{_fv},1,1,0);'''.format(_fn=f_name, _fw=f_width,
                                                                                        _fo=f_offset,
                                                                                        _f_volatile=f_volatile,
                                                                                        _frw=f_rw, _fv=f_init)
    reg_class = '''
class reg_{_bn}_{_rn} extends uvm_reg;
{_f_declare}
    virtual function void build();
{_f_build}
    endfunction

    `uvm_object_utils(reg_{_bn}_{_rn})
    function new(string name="reg_{_bn}_{_rn}");
        //parameter: name, size, has_coverage
        super.new(name, {_rdw}, UVM_NO_COVERAGE);
    endfunction
endclass
'''.format(_bn=subblock_name, _rn=reg_name, _f_declare=f_declare, _f_build=f_build, _rdw=reg_dw)
    return reg_class


def gen_subblk_reg_model_class(subblock_name, subblock_os, subblock_dw, subblock_list):
    r_array_declare = ''
    r_array_conect = ''
    r_declare = ''
    r_build = ''
    r_set_bkdr = ''
    h_subblock_os = subblock_os.replace('0x', '')
    #d_subblock_os = int(h_subblock_os, 16)
    d_subblock_os = int(0)
    for reg in subblock_list:
        if int(reg[6]) > 1:
            r_array_declare += '''      rand uvm_reg      {_reg_name}[{_reg_number}];\n'''.format(_reg_name=re.split('\d+$',reg[0])[0], _reg_number=reg[6])
            for i in range(0,int(reg[6])):
                r_array_conect += '''       {_reg_name}[{_i}] = {_reg_name}{_i};\n'''.format(_reg_name=re.split('\d+$',reg[0])[0], _i=i)
        r_name = reg[0]
        r_offset = reg[1].replace('0x', '')
        r_type = reg[2]
        r_depth = reg[3]
        # r_width = reg[4]
        r_rw = 'RW'
        r_rw_s = set()
        for field in reg[5]:
            if field[3] not in r_rw_s:
                r_rw_s.add(field[3])
        if 'RO' in r_rw_s and len(r_rw_s) == 1:
            r_rw = 'RO'
        elif 'WO' in r_rw_s and len(r_rw_s) == 1:
            r_rw = 'WO'
        # for field in reg[5]:
        #     if field[3] != 'RW':
        #         # r_rw = field[3]
        #         r_rw = 'RO'
        #         break
        if r_type == 'memory':
            r_declare += '    rand mem_{_bn}_{_rn} {_rn};\n'.format(_bn=subblock_name, _rn=r_name)
            r_build += '''
        {_rn} = mem_{_bn}_{_rn}::type_id::create("{_rn}",,get_full_name());
        {_rn}.configure(this,"");
        default_map.add_mem({_rn},'h{_ro});'''.format(_bn=subblock_name, _rn=r_name, _ro=r_offset)
            r_set_bkdr += '''
        begin
            reg_{_bn}_{_rn}_bkdr bkdr = new(this.{_rn}.get_full_name());
            this.{_rn}.set_backdoor(bkdr);
        end'''.format(_bn=subblock_name, _rn=r_name)
        else:
            if r_depth > 1:
                for i in range(r_depth):
                    r_declare += '    rand reg_{_bn}_{_rn} {_rn}_{_i};\n'.format(_bn=subblock_name, _rn=r_name, _i=i)
                    r_build += '''
        {_rn}_{_i} = reg_{_bn}_{_rn}::type_id::create("{_rn}_{_i}",,get_full_name());
        {_rn}_{_i}.configure(this,null,"");
        {_rn}_{_i}.build();
        default_map.add_reg({_rn}_{_i},'h{_ro},"{_rrw}");'''.format(_rn=r_name, _i=i, _bn=subblock_name, _ro=r_offset,
                                                                    _rrw=r_rw)
                    r_set_bkdr += '''
        begin
            reg_{_bn}_{_rn}_bkdr bkdr = new(this.{_rn}_{_i}.get_full_name());
            this.{_rn}_{_i}.set_backdoor(bkdr);
        end'''.format(_bn=subblock_name, _rn=r_name, _i=i, )
            else:
                r_declare += '    rand reg_{_bn}_{_rn} {_rn};\n'.format(_bn=subblock_name, _rn=r_name)
                r_build += '''
        {_rn} = reg_{_bn}_{_rn}::type_id::create("{_rn}",,get_full_name());
        {_rn}.configure(this,null,"");
        {_rn}.build();
        default_map.add_reg({_rn},'h{_ro},"{_rrw}");'''.format(_bn=subblock_name, _rn=r_name, _ro=r_offset, _rrw=r_rw)
                r_set_bkdr += '''
        begin
            reg_{_bn}_{_rn}_bkdr bkdr = new(this.{_rn}.get_full_name());
            this.{_rn}.set_backdoor(bkdr);
        end'''.format(_bn=subblock_name, _rn=r_name)
    subblock_byte_w = int(math.ceil(subblock_dw / 8))
    reg_class = '''
class {_sbn}_reg_model extends uvm_reg_block;
{_r_declare}
{_r_array_declare}
    virtual function void build();
        default_map = create_map("default_map",{_sbo},{_sbw},UVM_LITTLE_ENDIAN,1);
{_r_build}
{_r_array_conect}
        //setting backdoor
        `ifndef UVM_RAL_BACKDOOR_OFF
{_r_set_bkdr}
        `endif
    endfunction

    `uvm_object_utils({_sbn}_reg_model)

    function new(input string name="{_sbn}_reg_model");
        super.new(name, UVM_NO_COVERAGE);
    endfunction
endclass:{_sbn}_reg_model
'''.format(_sbn=subblock_name, _sbo=d_subblock_os, _r_declare=r_declare, _sbw=subblock_byte_w, _r_build=r_build,
           _r_set_bkdr=r_set_bkdr, _r_array_declare=r_array_declare, _r_array_conect=r_array_conect)
    return reg_class


def gen_subblk_reg_model_class2(subblock_name, subblock_os, subblock_dw, subblock_list):
    r_array_declare = ''
    r_array_conect = ''
    r_declare = ''
    r_build = ''
    r_set_bkdr = ''
    h_subblock_os = subblock_os.replace('0x', '')
    #d_subblock_os = int(h_subblock_os, 16)
    d_subblock_os = int(0)
    for reg in subblock_list:
        if int(reg[6]) > 1:
            r_array_declare += '''      rand uvm_reg      {_reg_name}[{_reg_number}];\n'''.format(_reg_name=re.split('\d+$',reg[0])[0], _reg_number=reg[6])
            for i in range(0,int(reg[6])):
                r_array_conect += '''       {_reg_name}[{_i}] = {_reg_name}{_i};\n'''.format(_reg_name=re.split('\d+$',reg[0])[0], _i=i)
        r_name = reg[0]
        r_offset = reg[1].replace('0x', '')
        r_type = reg[2]
        r_depth = reg[3]
        # r_width = reg[4]
        r_rw = 'RW'
        r_rw_s = set()
        for field in reg[5]:
            if field[3] not in r_rw_s:
                r_rw_s.add(field[3])
        if 'RO' in r_rw_s and len(r_rw_s) == 1:
            r_rw = 'RO'
        elif 'WO' in r_rw_s and len(r_rw_s) == 1:
            r_rw = 'WO'
        # for field in reg[5]:
        #     if field[3] != 'RW':
        #         # r_rw = field[3]
        #         r_rw = 'RO'
        #         break
        if r_type == 'memory':
            r_declare += '    rand mem_{_bn}_{_rn} {_rn};\n'.format(_bn=subblock_name, _rn=r_name)
            r_build += '''
        {_rn} = mem_{_bn}_{_rn}::type_id::create("{_rn}",,get_full_name());
        {_rn}.configure(this,"");
        default_map.add_mem({_rn},'h{_ro});'''.format(_bn=subblock_name, _rn=r_name, _ro=r_offset)
            r_set_bkdr += '''
        begin
            reg_{_bn}_{_rn}_bkdr bkdr = new(this.{_rn}.get_full_name());
            this.{_rn}.set_backdoor(bkdr);
        end'''.format(_bn=subblock_name, _rn=r_name)
        else:
            if r_depth > 1:
                for i in range(r_depth):
                    r_declare += '    rand reg_{_bn}_{_rn} {_rn}_{_i};\n'.format(_bn=subblock_name, _rn=r_name, _i=i)
                    r_build += '''
        {_rn}_{_i} = reg_{_bn}_{_rn}::type_id::create("{_rn}_{_i}",,get_full_name());
        {_rn}_{_i}.configure(this,null,"");
        {_rn}_{_i}.build();
        default_map.add_reg({_rn}_{_i},'h{_ro},"{_rrw}");'''.format(_rn=r_name, _i=i, _bn=subblock_name, _ro=r_offset,
                                                                    _rrw=r_rw)
                    r_set_bkdr += '''
        begin
            reg_{_bn}_{_rn}_bkdr bkdr = new(this.{_rn}_{_i}.get_full_name());
            bkdr.bkdr_if = {_bn}_reg_bkdr_if_i;
            this.{_rn}_{_i}.set_backdoor(bkdr);
        end'''.format(_bn=subblock_name, _rn=r_name, _i=i, )
            else:
                r_declare += '    rand reg_{_bn}_{_rn} {_rn};\n'.format(_bn=subblock_name, _rn=r_name)
                r_build += '''
        {_rn} = reg_{_bn}_{_rn}::type_id::create("{_rn}",,get_full_name());
        {_rn}.configure(this,null,"");
        {_rn}.build();
        default_map.add_reg({_rn},'h{_ro},"{_rrw}");'''.format(_bn=subblock_name, _rn=r_name, _ro=r_offset, _rrw=r_rw)
                r_set_bkdr += '''
        begin
            reg_{_bn}_{_rn}_bkdr bkdr = new(this.{_rn}.get_full_name());
            bkdr.bkdr_if = {_bn}_reg_bkdr_if_i;
            this.{_rn}.set_backdoor(bkdr);
        end'''.format(_bn=subblock_name, _rn=r_name)
    subblock_byte_w = int(math.ceil(subblock_dw / 8))
    reg_class = '''
class {_sbn}_reg_model extends uvm_reg_block;
    virtual {_sbn}_reg_bkdr_intf {_sbn}_reg_bkdr_if_i;
{_r_declare}
{_r_array_declare}
    virtual function void build();
        default_map = create_map("default_map",{_sbo},{_sbw},UVM_LITTLE_ENDIAN,1);
{_r_build}
{_r_array_conect}
        //setting backdoor
        `ifndef UVM_RAL_BACKDOOR_OFF
{_r_set_bkdr}
        `endif
    endfunction

    `uvm_object_utils({_sbn}_reg_model)

    function new(input string name="{_sbn}_reg_model");
        super.new(name, UVM_NO_COVERAGE);
    endfunction
endclass:{_sbn}_reg_model
'''.format(_sbn=subblock_name, _sbo=d_subblock_os, _r_declare=r_declare, _sbw=subblock_byte_w, _r_build=r_build,
           _r_set_bkdr=r_set_bkdr, _r_array_declare=r_array_declare, _r_array_conect=r_array_conect)
    return reg_class


def gen_prj_reg_model_class(prj_list, block_map_dict):
    b_declare = ''
    b_build = ''
    for key in block_map_dict.keys():
        sub_name = key
        sub_offset = block_map_dict[key][1].replace('0x', "'h")
        b_declare += '  {_sbn}_reg_model {_sbn};\n'.format(_sbn=sub_name)
        b_build += '''
        {_sbn} = {_sbn}_reg_model::type_id::create("{_sbn}");
        {_sbn}.configure(this,"");
        {_sbn}.build();
        {_sbn}.lock_model();
        default_map.add_submap({_sbn}.default_map,{_sbo});
'''.format(_sbn=sub_name, _sbo=sub_offset)
    prj_byte_w = int(math.ceil(prj_list[2] / 8))
    reg_class = '''
class {_pn}_reg_model extends uvm_reg_block;
{_b_declare}
    virtual function void build();
        default_map = create_map("default_map",{_pba},{_pbw},UVM_LITTLE_ENDIAN,1);
{_b_build}
    endfunction

    `uvm_object_utils({_pn}_reg_model)

    function new(input string name="{_pn}_reg_model");
        super.new(name, UVM_NO_COVERAGE);
    endfunction
endclass:{_pn}_reg_model
'''.format(_pn=prj_list[0], _b_declare=b_declare, _pba=prj_list[1].replace('0x', "'h"), _pbw=prj_byte_w,
           _b_build=b_build)
    return reg_class

def gen_prj_reg_model_class2(prj_list, block_map_dict, file_context_para):
    b_declare = ''
    b_build = ''
    for key in block_map_dict.keys():
        sub_name = key
        sub_offset = block_map_dict[key][1].replace('0x', "'h")
        sub_blocksize = block_map_dict[key][3].replace('Bytes', "")
        b_declare += '  {_sbn}_reg_model {_sbn}[{_usbn}_ICNT];\n'.format(_sbn=sub_name, _usbn=sub_name.upper())
        b_declare += '  virtual {_sbn}_reg_bkdr_intf {_sbn}_reg_bkdr_intf_i[{_usbn}_ICNT];\n'.format(_sbn=sub_name, _usbn=sub_name.upper())
        b_build += '''
    for(int i=0;i<({_usbn}_ICNT);i++) begin
        uvm_config_db#(virtual {_sbn}_reg_bkdr_intf)::get(null,"",$sformatf("{_sbn}_reg_bkdr_intf_i[%0d]",i),{_sbn}_reg_bkdr_intf_i[i]);

        {_sbn}[i] = {_sbn}_reg_model::type_id::create($sformatf("{_sbn}%0d",i));
        {_sbn}[i].{_sbn}_reg_bkdr_if_i = {_sbn}_reg_bkdr_intf_i[i];
        {_sbn}[i].configure(this,"");
        {_sbn}[i].build();
        {_sbn}[i].lock_model();
        default_map.add_submap({_sbn}[i].default_map,{_sbo}+i*{_sbs});
    end
'''.format(_sbn=sub_name, _usbn=sub_name.upper(), _pjn=prj_list[0], _sbo=sub_offset, _sbs=int(sub_blocksize))
    prj_byte_w = int(math.ceil(prj_list[2] / 8))
    reg_class = '''
class {_pn}_reg_model #(\n{_file_context_para}) extends uvm_reg_block;\n
    //virtual {_pn}_reg_bkdr_wrapper_intf {_pn}_reg_bkdr_wrapper_intf_i;\n
{_b_declare}
    virtual function void build();
        default_map = create_map("default_map",{_pba},{_pbw},UVM_LITTLE_ENDIAN,1);
{_b_build}
    endfunction

    `uvm_object_utils({_pn}_reg_model)

    function new(input string name="{_pn}_reg_model");
        super.new(name, UVM_NO_COVERAGE);
    endfunction
endclass:{_pn}_reg_model
'''.format(_pn=prj_list[0], _b_declare=b_declare, _pba=prj_list[1].replace('0x', "'h"), _pbw=prj_byte_w,
           _b_build=b_build, _file_context_para=file_context_para)
    return reg_class


def gen_reg_model_file(name, file_context):
    file_path = 'reg_model/src'
    file_name = '{}_reg_model.sv'.format(name)
    title = gen_reg_model_title(name)
    context = '''{_title}
{_f_context}
`endif
'''.format(_title=title, _f_context=file_context)
    gen_file(file_path, file_name, context)

def gen_reg_model_file2(name, file_context):
    file_path = 'reg_model2/src'
    file_name = '{}_reg_model.sv'.format(name)
    title = gen_reg_model_title(name)
    context = '''{_title}
{_f_context}
`endif
'''.format(_title=title, _f_context=file_context)
    gen_file(file_path, file_name, context)

def gen_reg_bkdr_model_file(name, file_context):
    file_path = 'reg_model/src'
    file_name = '{}_reg_model.sv'.format(name)
    title = gen_reg_model_title(name)
    context = '''{_title}
`ifndef UVM_RAL_BACKDOOR_OFF
{_f_context}
`endif
`endif
'''.format(_title=title, _f_context=file_context)
    gen_file(file_path, file_name, context)


def gen_reg_bkdr_model_file2(name, file_context):
    file_path = 'reg_model2/src'
    file_name = '{}_reg_model.sv'.format(name)
    title = gen_reg_model_title(name)
    context = '''{_title}
`ifndef UVM_RAL_BACKDOOR_OFF
{_f_context}
`endif
`endif
'''.format(_title=title, _f_context=file_context)
    gen_file(file_path, file_name, context)


def gen_reg_bkdr_intf_file(name, file_context):
    file_path = 'reg_model/src'
    file_name = '{}_reg_bkdr_intf.sv'.format(name)
    title = gen_reg_bkdr_intf_title(name)
    context = '''{_title}
`ifndef UVM_RAL_BACKDOOR_OFF
interface {_bn}_reg_bkdr_intf;
{_f_context}
endinterface
`endif
`endif
'''.format(_bn=name, _title=title, _f_context=file_context)
    gen_file(file_path, file_name, context)


def gen_reg_bkdr_intf_file2(name, file_context):
    file_path = 'reg_model2/src'
    file_name = '{}_reg_bkdr_intf.sv'.format(name)
    title = gen_reg_bkdr_intf_title(name)
    context = '''{_title}
interface {_bn}_reg_bkdr_intf;
`ifndef UVM_RAL_BACKDOOR_OFF
{_f_context}
`endif
endinterface
//`endif
`endif
'''.format(_bn=name, _title=title, _f_context=file_context)
    gen_file(file_path, file_name, context)

def gen_reg_bkdr_wrapper_intf_file2(name, file_context, file_context_para):
    file_path = 'reg_model2/src'
    file_name = '{}_reg_bkdr_wrapper_intf.sv'.format(name)
    title = gen_reg_bkdr_intf_title(name)
    context = '''{_title}
interface {_bn}_reg_bkdr_wrapper_intf #(\n{_f_context_para});\n
`ifndef UVM_RAL_BACKDOOR_OFF
{_f_context}
`endif
endinterface
//`endif
`endif
'''.format(_bn=name, _title=title, _f_context=file_context, _f_context_para=file_context_para)
    gen_file(file_path, file_name, context)


def gen_reg_model_file_list(prj_name, block_map_dict):
    file_path = './reg_model'
    file_name = '{}_reg_model.f'.format(prj_name)
    context = '\n'
    for key in block_map_dict.keys():
        context += './src/{}_bkdr_reg_model.sv\n'.format(key)
        context += './src/{}_reg_model.sv\n'.format(key)
    context += './src/{}_reg_model.sv\n'.format(prj_name)
    context += './src/{}_reg_bkdr_intf.sv\n'.format(prj_name)
    gen_file(file_path, file_name, context)

def gen_reg_model_file_list2(prj_name, block_map_dict):
    file_path = './reg_model2'
    file_name = '{}_reg_model.f'.format(prj_name)
    context = '\n'
    context += '//+incdir+./src\n'
    context += '//{}_reg_model_pkg.sv\n'.format(prj_name)
    for key in block_map_dict.keys():
        context += './src/{}_reg_bkdr_intf.sv\n'.format(key)
        context += './src/{}_bkdr_reg_model.sv\n'.format(key)
        context += './src/{}_reg_model.sv\n'.format(key)
    context += '//./src/{}_reg_bkdr_wrapper_intf.sv\n'.format(prj_name)
    context += './src/{}_reg_model.sv\n'.format(prj_name)
    gen_file(file_path, file_name, context)


def gen_reg_model_pkg2(prj_name, block_map_dict):
    file_path = './reg_model2'
    file_name = '{}_reg_model_pkg.sv'.format(prj_name)
    context = '\n'
    context += '`ifndef {}_REG_MODEL_PKG__SV\n'.format(prj_name.upper())
    context += '`define {}_REG_MODEL_PKG__SV\n'.format(prj_name.upper())
    context += '\n'
    for key in block_map_dict.keys():
        context += '`include "./src/{}_reg_bkdr_intf.sv"\n'.format(key)
    context += '//`include "./src/{}_reg_bkdr_wrapper_intf.sv"\n'.format(prj_name)
    context += '\n'
    context += 'package {}_reg_model_pkg;\n'.format(prj_name)
    context += '    import uvm_pkg::*;\n'
    for key in block_map_dict.keys():
        context += '    //`include "./src/{}_reg_bkdr_intf.sv"\n'.format(key)
        context += '    `include "./src/{}_bkdr_reg_model.sv"\n'.format(key)
        context += '    `include "./src/{}_reg_model.sv"\n'.format(key)
    context += '    //`include "./src/{}_reg_bkdr_wrapper_intf.sv"\n'.format(prj_name)
    context += '    `include "./src/{}_reg_model.sv"\n'.format(prj_name)
    context += 'endpackage\n'
    context += '`endif\n'
    gen_file(file_path, file_name, context)


def xml2sv(project_list, block_map_dict, subblock_dict):
    ##instance_number Expand
    new_block_map_dict = copy.deepcopy(block_map_dict)
    new_subblock_dict = copy.deepcopy(subblock_dict)
    for block_name in block_map_dict.keys():
        if int(block_map_dict[block_name][5]) > 1:
            for i in range(0, int(block_map_dict[block_name][5])):
                new_block_name = block_name + str(i)
                new_block_offset = hex(int(re.sub('0x', '', block_map_dict[block_name][1]), 16) + int(
                    re.sub('Bytes', '', block_map_dict[block_name][3]), 10) * int(i))
                ##Modify offset address
                temp_block_map = list(block_map_dict[block_name])
                temp_block_map[1] = new_block_offset
                new_block_map_dict[new_block_name] = tuple(temp_block_map)
                new_subblock_dict[new_block_name] = subblock_dict[block_name]
            del new_block_map_dict[block_name]
            del new_subblock_dict[block_name]
    ##file list
    gen_reg_model_file_list(project_list[0], new_block_map_dict)
    gen_reg_model_file_list2(project_list[0], new_block_map_dict)
    gen_reg_model_pkg2(project_list[0], new_block_map_dict)
    ##project top reg model
    prj_context = gen_prj_reg_model_class(project_list, new_block_map_dict)
    gen_reg_model_file(project_list[0], prj_context)
    ##sub-block reg model
    s_bkdr_intf_context = ''
    s_bkdr_intf_context2 = ''
    s_bkdr_intf_context2_para = ''
    for subblock in new_subblock_dict.keys():
        sub_context = ''
        bkdr_context = ''
        b_bkdr_intf_context = ''
        sub_context2 = ''
        bkdr_context2 = ''
        b_bkdr_intf_context2 = ''
        for reg in new_subblock_dict[subblock]:
            if reg[2] == 'memory':
                sub_context += gen_mem_model_class(subblock, reg[0], reg[4], reg[3])
            else:
                # for i in range(reg[3]):
                sub_context += gen_reg_model_class(subblock, reg[0], reg[4], reg[5])
                sub_context2 += gen_reg_model_class(subblock, reg[0], reg[4], reg[5])
            bkdr_context += gen_reg_model_backdoor_class(subblock, reg[0], reg[2], reg[5])
            bkdr_context2 += gen_reg_model_backdoor_class2(subblock, reg[0], reg[2], reg[5])
            b_bkdr_intf_context += gen_reg_backdoor_interface(subblock, reg[0], reg[2], reg[5])
            b_bkdr_intf_context2 += gen_reg_backdoor_interface2(subblock, reg[0], reg[2], reg[5])
        s_bkdr_intf_context += b_bkdr_intf_context
        s_bkdr_intf_context2_para += '      int {_ubn}_ICNT=1,\n'.format(_ubn=subblock.upper())
        s_bkdr_intf_context2 += '{_bn}_reg_bkdr_intf      {_bn}_reg_bkdr_intf_i[{_ubn}_ICNT]();\n'.format(_bn=subblock,
                                                                                                _ubn=subblock.upper())
        sub_context += gen_subblk_reg_model_class(subblock, new_block_map_dict[subblock][1],
                                                  new_block_map_dict[subblock][2],
                                                  new_subblock_dict[subblock])
        sub_context2 += gen_subblk_reg_model_class2(subblock, new_block_map_dict[subblock][1],
                                                    new_block_map_dict[subblock][2],
                                                    new_subblock_dict[subblock])
        gen_reg_model_file(subblock, sub_context)
        gen_reg_model_file2(subblock, sub_context2)
        gen_reg_bkdr_model_file('{}_bkdr'.format(subblock), bkdr_context)
        gen_reg_bkdr_model_file2('{}_bkdr'.format(subblock), bkdr_context2)
        gen_reg_bkdr_intf_file(subblock, b_bkdr_intf_context)
        gen_reg_bkdr_intf_file2(subblock, b_bkdr_intf_context2)
    gen_reg_bkdr_intf_file(project_list[0], s_bkdr_intf_context)
    s_bkdr_intf_context2_para = s_bkdr_intf_context2_para.strip(',\n')
    gen_reg_bkdr_wrapper_intf_file2(project_list[0], s_bkdr_intf_context2, s_bkdr_intf_context2_para)
    prj_context2 = gen_prj_reg_model_class2(project_list, new_block_map_dict, s_bkdr_intf_context2_para)
    gen_reg_model_file2(project_list[0], prj_context2)


# ===========================generate sv(register model) end  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# ===============generate verilog(register rtl code) begin>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# def gen_filed_common(subblock_name):
def gen_filed_common():
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    # file_path = './register_v/{}'.format(subblock_name)
    file_path = './register_v/common/module'
    file_name = 'field_common.v'
    context = '''//=========================================================
//File name    : field_common.v
//Author       : Heterogeneous Computing Group
//Module name  : field_common
//Discribution : field description
//Date         : {_curr_time}
//=========================================================
`ifndef FIELD_COMMON__SV
`define FIELD_COMMON__SV

module field_common 
    #(
        parameter FIELD_WIDTH = 1,
        parameter FIELD_ACCESS = "RW",
        parameter FIELD_DEFAULT = 1'b0
     )
    (
        input                         clk          , 
        input                         rst_n        ,
        input                         field_up_en  ,
        input       [FIELD_WIDTH-1:0] field_up     ,
        input                         field_wr_en  ,
        input       [FIELD_WIDTH-1:0] field_wr     ,
        input                         field_rd_en  ,
        output wire [FIELD_WIDTH-1:0] field_rd_out ,
        output wire [FIELD_WIDTH-1:0] field_out    
    );

reg [FIELD_WIDTH-1:0] field;
wire [FIELD_WIDTH-1:0] field_din;
wire [FIELD_WIDTH-1:0] field_after_up;
always @(posedge clk or negedge rst_n) begin
    if(rst_n==1'b0) begin
        field <= FIELD_DEFAULT;
    end
    else begin
        field <= field_din;
    end
end

assign field_after_up = field_up;

generate
    case(FIELD_ACCESS)
        "RW" : begin
            assign field_din = field_wr_en==1'b1 ? field_wr : field_up_en==1'b1 ? field_after_up : field;
            assign field_rd_out = field;
        end
        "RWHW" : begin
            assign field_din = (field_up_en==1'b1) ? field_after_up : (field_wr_en==1'b1) ? field_wr : field;
            assign field_rd_out = field;
        end        
        "WRC" : begin
            assign field_din = field_wr_en==1'b1 ? field_wr : field_rd_en==1'b1 ? field_up_en==1'b1 ? field_after_up : {{FIELD_WIDTH{{1'b0}}}} : field_up_en==1'b1 ? field_after_up : field;
            assign field_rd_out = field;
        end
        "W1C" : begin
            if(FIELD_WIDTH==1) begin
                assign field_din = (field_up_en==1'b1) ? field_after_up : (field_wr_en==1'b1 & field_wr==1'b1) ? {{FIELD_WIDTH{{1'b0}}}} : field;
            end
            else begin
                assign field_din = (field_up_en==1'b1) ? field_after_up : (field_wr_en==1'b1 & field_wr=={{{{(FIELD_WIDTH-1){{1'b0}}}},1'b1}}) ? {{FIELD_WIDTH{{1'b0}}}} : field;
            end
            assign field_rd_out = field;
        end
        "W1S" : begin
            if(FIELD_WIDTH==1) begin
                assign field_din = field_wr_en==1'b1 & field_wr==1'b1 ? {{FIELD_WIDTH{{1'b1}}}} : field_up_en==1'b1 ? field_after_up : field;
            end
            else begin
                assign field_din = field_wr_en==1'b1 & field_wr=={{{{(FIELD_WIDTH-1){{1'b0}}}},1'b1}} ? {{FIELD_WIDTH{{1'b1}}}} : field_up_en==1'b1 ? field_after_up : field;
            end
            assign field_rd_out = field;
        end
        "WO" : begin
            assign field_din = field_wr_en==1'b1 ? field_wr : field_up_en==1'b1 ? field_after_up : field;
            assign field_rd_out = {{FIELD_WIDTH{{1'b0}}}};
        end
        "RU" : begin
            assign field_din = field_wr_en==1'b1 ? field_wr : field_up_en==1'b1 ? field_after_up : field;
            assign field_rd_out = field;            
        end
        default : begin : DAFULT_GEN
            not_exit next_exit();
        end
    endcase
endgenerate

assign field_out = field;

endmodule

`endif
'''.format(_curr_time=curr_time)
    gen_file(file_path, file_name, context)


# def gen_filed_ro(subblock_name):
def gen_filed_ro():
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    # file_path = './register_v/{}'.format(subblock_name)
    file_path = './register_v/common/module'
    file_name = 'field_ro.v'
    context = '''//=========================================================
//File name    : field_ro.v
//Author       : Heterogeneous Computing Group
//Module name  : field_ro
//Discribution : field description
//Date         : {_curr_time}
//=========================================================
`ifndef FIELD_RO__SV
`define FIELD_RO__SV

module field_ro 
    #(
        parameter FIELD_WIDTH = 1
     )
    (
        input       [FIELD_WIDTH-1:0] field_up     ,
        output wire [FIELD_WIDTH-1:0] field_out ,        
        output wire [FIELD_WIDTH-1:0] field_rd_out 
    );

wire [FIELD_WIDTH-1:0] field;

assign field = field_up;
assign field_rd_out = field;
assign field_out = field;

endmodule

`endif
'''.format(_curr_time=curr_time)
    gen_file(file_path, file_name, context)


def gen_reg(subblock_name, reg_name, reg_dw, reg_list):
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    file_path = './register_v/{}/module'.format(subblock_name)
    file_name = 'reg_{_bn}_{_name}.v'.format(_bn=subblock_name, _name=reg_name)
    rsv_assign = ''
    field_declare1 = ''
    field_declare2 = ''
    field_declare3 = ''
    field_declare4 = ''
    field_declare5 = ''
    field_assign1 = ''
    field_assign2 = ''
    field_assign3 = ''
    field_assign5 = ''
    declare_if_logic_in = ''
    declare_if_logic_out = ''
    declare_if_mdpt_in = ''
    declare_if_mdpt_out = ''
    declare_if_mdpt_in_again = ''
    declare_if_mdpt_out_again = ''
    field_inst = ''
    pre_msb = 0
    rsv_cnt = 0
    reg_write = 'reg_write'
    for field in reg_list:
        field_up_signal = ''
        field_up_en_signal = ''
        f_name = field[0]
        f_offset = int(field[1]) % reg_dw
        f_width = int(field[2])
        f_init = field[4].replace("0x", "'h")
        f_rw = field[3]
        reg_write = 'reg_write'
        if f_rw in ['RU']:
            reg_write = '1\'b0'
        if f_rw not in {'WO'}:
            field_assign3 += 'assign f_{}_rd = r_reg_out_rd;\n'.format(f_name)
        if f_rw not in {'RW', 'WO'}:
            declare_if_mdpt_in += '                     output f_{}_{}_in,\n'.format(reg_name, f_name)
            declare_if_mdpt_in_again += '                     input f_{}_{}_in,\n'.format(reg_name, f_name)
        if f_rw not in {'WO'}:
            declare_if_mdpt_out += '                        input f_{}_{}_rd,\n'.format(reg_name, f_name)
            declare_if_mdpt_out_again += '                        output f_{}_{}_rd,\n'.format(reg_name, f_name)
            declare_if_logic_out += 'logic             f_{}_{}_rd;\n'.format(reg_name, f_name)
        if f_rw not in {'RO', 'RC' , 'RU'}:
            if f_rw in['RWHW']:
                field_assign3 += 'assign f_{}_wr = r_reg_out_wr | f_{}_up_en_r;\n'.format(f_name,f_name)
                field_assign5 += '''
always @(posedge clk or negedge rst_n)
    if(!rst_n) begin
        f_{}_up_en_r <= 0;
    end
    else begin
        f_{}_up_en_r <= f_{}_up_en;
    end
                '''.format(f_name,f_name,f_name)
            else:
                field_assign3 += 'assign f_{}_wr = r_reg_out_wr;\n'.format(f_name)
            declare_if_logic_out += 'logic             f_{}_{}_wr;\n'.format(reg_name, f_name)
            declare_if_mdpt_out += '                        input f_{}_{}_wr,\n'.format(reg_name, f_name)
            declare_if_mdpt_out_again += '                        output f_{}_{}_wr,\n'.format(reg_name, f_name)
        if pre_msb != f_offset:
            rsv_assign += "assign rsv_{}={}'h0;\n".format(rsv_cnt, f_offset - pre_msb)
            if (f_offset - pre_msb) == 1:
                field_declare1 += 'wire        rsv_{};\n'.format(rsv_cnt)
                field_assign2 += 'assign reg_rd_[{}] = rsv_{};\n'.format(pre_msb, rsv_cnt)
            else:
                field_declare1 += 'wire [{}:0] rsv_{};\n'.format(str(f_offset - pre_msb - 1).rjust(2), rsv_cnt)
                field_assign2 += 'assign reg_rd_[{}:{}] = rsv_{};\n'.format(f_offset - 1, pre_msb, rsv_cnt)
        if f_width == 1:
            field_declare1 += 'wire        f_{};\n'.format(f_name)
            field_declare2 += 'wire        f_rd_{};\n'.format(f_name)
            if f_rw in ['RWHW']:
                field_declare5 += 'reg      f_{}_up_en_r;\n'.format(f_name)
            if f_rw not in ['RO', 'RC']:
                field_assign1 += 'assign f_{_f_name}_out = f_{_f_name};\n'.format(_f_name=f_name)
            field_assign2 += 'assign reg_rd_[{}] = f_rd_{};\n'.format(f_offset, f_name)
            if f_rw not in ['RW', 'WO']:
                declare_if_logic_in += 'logic             f_{}_{}_in;\n'.format(reg_name, f_name)
            if f_rw not in ['RW', 'WO']:
                field_declare3 += 'input                       f_{}_up_data,\n        '.format(f_name)
            if f_rw not in ['RO', 'RC']:
                if f_rw not in ['RW', 'WO']:
                    declare_if_logic_in += 'logic             f_{}_{}_vld;\n'.format(reg_name, f_name)
                    declare_if_mdpt_in += '                     output f_{}_{}_vld,\n'.format(reg_name, f_name)
                    declare_if_mdpt_in_again += '                     input f_{}_{}_vld,\n'.format(reg_name, f_name)
                declare_if_logic_out += 'logic             f_{}_{}_out;\n'.format(reg_name, f_name)
                declare_if_mdpt_out += '                        input f_{}_{}_out,\n'.format(reg_name, f_name)
                declare_if_mdpt_out_again += '                        output f_{}_{}_out,\n'.format(reg_name, f_name)
                if f_rw not in ['RW', 'WO']:
                    field_declare3 += 'input                       f_{}_up_en,\n        '.format(f_name)
                    field_up_signal += 'f_{_f_name}_up_data'.format(_f_name=f_name)
                    field_up_en_signal += 'f_{_f_name}_up_en'.format(_f_name=f_name)
                else:
                    field_up_signal += '''{}'b0'''.format(f_width)
                    field_up_en_signal += "1'b0"
                field_declare4 += 'output                      f_{}_out,\n        '.format(f_name)
                if f_rw not in {'WO'}:
                    field_declare4 += 'output                      f_{}_rd,\n        '.format(f_name)
                if f_rw not in ['RC', 'RU']:
                    field_declare4 += 'output                      f_{}_wr,\n        '.format(f_name)
                field_inst += '''
field_common 
    #(
        .FIELD_ACCESS("{_f_rw}"), 
        .FIELD_DEFAULT(1{_f_init})
     ) u_f_{_f_name} 
    (
        .clk          ( clk             ), 
        .rst_n        ( rst_n           ),
        .field_up_en  ( {_field_up_en_signal}   ),
        .field_up     ( {_field_up_signal} ),
        .field_wr_en  ( {_reg_write}       ),
        .field_wr     ( reg_wr_data[{_f_offset}] ),
        .field_rd_en  ( reg_read        ),
        .field_rd_out ( f_rd_{_f_name}    ),
        .field_out    ( f_{_f_name} )
    );'''.format(_f_rw=f_rw, _f_init=f_init, _f_name=f_name, _f_offset=str(f_offset).rjust(2),
                 _field_up_en_signal=field_up_en_signal, _field_up_signal=field_up_signal, _reg_write=reg_write)
            else:
                field_declare4 += 'output                      f_{}_rd,\n        '.format(f_name)
                field_inst += '''
field_ro 
    #(
     ) u_f_{_f_name} 
    (
        .field_up     ( f_{_f_name}_up_data ),
        .field_rd_out ( f_{_f_name}    ),
        .field_out    ( f_rd_{_f_name} )
    );'''.format(_f_name=f_name, _f_offset=str(f_offset).rjust(2))

        else:
            reg_write = 'reg_write'
            if f_rw in ['RU']:
                reg_write = '1\'b0'
            field_declare1 += 'wire [{}:0] f_{};\n'.format(str(f_width - 1).rjust(2), f_name)
            field_declare2 += 'wire [{}:0] f_rd_{};\n'.format(str(f_width - 1).rjust(2), f_name)
            if f_rw in ['RWHW']:
                field_declare5 += 'reg [{}:0] f_{}_up_en_r;\n'.format(str(f_width - 1).rjust(2), f_name)
            if f_rw not in ['RO', 'RC']:
                field_assign1 += 'assign f_{_f_name}_out = f_{_f_name};\n'.format(_f_name=f_name)
            field_assign2 += 'assign reg_rd_[{}:{}] = f_rd_{};\n'.format(f_width + f_offset - 1, f_offset, f_name)
            if f_rw not in ['RW', 'WO']:
                declare_if_logic_in += 'logic[{}:0]         f_{}_{}_in;\n'.format(str(f_width - 1).rjust(2), reg_name,
                                                                                  f_name)
            if f_rw not in ['RW', 'WO']:
                field_declare3 += 'input[{}:0]                 f_{}_up_data,\n        '.format(
                    str(f_width - 1).rjust(2), f_name)
            if f_rw not in ['RO', 'RC']:
                if f_rw not in ['RW', 'WO']:
                    declare_if_logic_in += 'logic             f_{}_{}_vld;\n'.format(reg_name, f_name)
                    declare_if_mdpt_in += '                     output f_{}_{}_vld,\n'.format(reg_name, f_name)
                    declare_if_mdpt_in_again += '                     input f_{}_{}_vld,\n'.format(reg_name, f_name)
                declare_if_logic_out += 'logic[{}:0]       f_{}_{}_out;\n'.format(str(f_width - 1).rjust(2), reg_name,
                                                                                  f_name)
                declare_if_mdpt_out += '                        input f_{}_{}_out,\n'.format(reg_name, f_name)
                declare_if_mdpt_out_again += '                        output f_{}_{}_out,\n'.format(reg_name, f_name)
                if f_rw not in ['RW', 'WO']:
                    field_declare3 += 'input                       f_{}_up_en,\n        '.format(f_name)
                    field_up_signal += 'f_{_f_name}_up_data'.format(_f_name=f_name)
                    field_up_en_signal += 'f_{_f_name}_up_en'.format(_f_name=f_name)
                else:
                    field_up_signal += '''{}'b0'''.format(f_width)
                    field_up_en_signal += "1'b0"
                field_declare4 += 'output[{}:0]                f_{}_out,\n        '.format(str(f_width - 1).rjust(2),
                                                                                           f_name)
                if f_rw not in {'WO'}:
                    field_declare4 += 'output                      f_{}_rd,\n        '.format(f_name)
                if f_rw not in ['RC', 'RU']:
                    field_declare4 += 'output                      f_{}_wr,\n        '.format(f_name)
                field_inst += '''
field_common 
    #(
        .FIELD_WIDTH({_f_width}), 
        .FIELD_ACCESS("{_f_rw}"), 
        .FIELD_DEFAULT({_f_width}{_f_init})
     ) u_f_{_f_name} 
    (
        .clk          ( clk                ), 
        .rst_n        ( rst_n              ),
        .field_up_en  ( {_field_up_en_signal} ),
        .field_up     ( {_field_up_signal} ),
        .field_wr_en  ( {_reg_write}          ),
        .field_wr     ( reg_wr_data[{_f_msb}:{_f_offset}] ),
        .field_rd_en  ( reg_read           ),
        .field_rd_out ( f_rd_{_f_name}    ),
        .field_out    ( f_{_f_name} )
    );'''.format(_f_width=f_width, _f_rw=f_rw, _f_init=f_init, _f_name=f_name, _f_offset=str(f_offset).rjust(2),
                 _f_msb=str(f_width + f_offset - 1).rjust(2), _field_up_en_signal=field_up_en_signal,
                 _field_up_signal=field_up_signal, _reg_write=reg_write)
            else:
                field_declare4 += 'output                    f_{}_rd,\n        '.format(f_name)
                field_inst += '''
field_ro 
    #(
        .FIELD_WIDTH({_f_width}) 
     ) u_f_{_f_name} 
    (
        .field_up     ( f_{_f_name}_up_data ),
        .field_rd_out ( f_{_f_name}    ),
        .field_out    ( f_rd_{_f_name} )
    );'''.format(_f_width=f_width, _f_name=f_name, _f_offset=str(f_offset).rjust(2),
                 _f_msb=str(f_width + f_offset - 1).rjust(2))

        pre_msb = f_offset + f_width
        rsv_cnt += 1
    if pre_msb != reg_dw:
        rsv_assign += "assign rsv_{}={}'h0;\n".format(rsv_cnt, reg_dw - pre_msb)
        if reg_dw - pre_msb == 1:
            field_declare1 += 'wire        rsv_{};\n'.format(rsv_cnt)
            field_assign2 += 'assign reg_rd_[{}] = rsv_{};\n'.format(pre_msb, rsv_cnt)
        else:
            field_declare1 += 'wire [{}:0] rsv_{};\n'.format(str(reg_dw - pre_msb - 1).rjust(2), rsv_cnt)
            field_assign2 += 'assign reg_rd_[{}:{}] = rsv_{};\n'.format(reg_dw - 1, pre_msb, rsv_cnt)
    context = '''//=========================================================
//File name    : reg_{_name}.v
//Author       : Heterogeneous Computing Group
//Module name  : reg_{_name}
//Discribution : register description
//Date         : {_curr_time}
//=========================================================
`ifndef REG_{_Ubn}_{_Uname}__SV
`define REG_{_Ubn}_{_Uname}__SV

module reg_{_bn}_{_name}
    #(
        parameter REG_WIDTH = {_r_width}
     )
    (
        input                       clk        , 
        input                       rst_n      ,
        
        {_field_declare3}
        {_field_declare4}
        input                       reg_wr_sel ,
        input                       reg_wr_rd  ,//1: write; 0: read
        input       [REG_WIDTH-1:0] reg_wr_data,
        output wire [REG_WIDTH-1:0] reg_rd_out 
    );

//register declare
wire [REG_WIDTH-1:0] reg_rd_;
wire reg_write;
wire reg_read;
reg r_reg_out_wr;
reg r_reg_out_rd;
//field declare
{_field_declare1}
//field read declare
{_field_declare2}
//field hw up declare
{_field_declare5}

assign reg_write = reg_wr_sel==1'b1 && reg_wr_rd==1'b1;
assign reg_read  = reg_wr_sel==1'b1 && reg_wr_rd==1'b0;

{_field_assign3}
{_field_assign5}

always @(posedge clk or negedge rst_n)
    if(!rst_n) begin
        r_reg_out_wr <= 0;
        r_reg_out_rd <= 0;
    end
    else begin
        r_reg_out_wr <= reg_write;
        r_reg_out_rd <= reg_read;
    end
//reserved tie 0
{_rsv_assign}
//field instance
{_field_inst}

//register output
{_field_assign1}
{_field_assign2}
assign reg_rd_out = reg_rd_;

endmodule

`endif
'''.format(_curr_time=curr_time, _bn=subblock_name, _name=reg_name, _Ubn=subblock_name.upper(), _Uname=reg_name.upper(),
           _r_width=reg_dw,
           _field_declare1=field_declare1, _field_declare2=field_declare2, _field_declare5=field_declare5, _field_declare3=field_declare3,
           _field_declare4=field_declare4, _rsv_assign=rsv_assign, _field_inst=field_inst, _field_assign1=field_assign1,
           _field_assign2=field_assign2, _field_assign3=field_assign3, _field_assign5=field_assign5)
    gen_file(file_path, file_name, context)
    return declare_if_logic_in, declare_if_logic_out, declare_if_mdpt_in, declare_if_mdpt_out, \
           declare_if_mdpt_in_again, declare_if_mdpt_out_again


def gen_reg2(subblock_name, reg_name, reg_dw, reg_list):
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    file_path = './register_v/{}/module'.format(subblock_name)
    file_name = 'reg_{_bn}_{_name}.v'.format(_bn=subblock_name, _name=reg_name)
    rsv_assign = ''
    field_declare1 = ''
    field_declare2 = ''
    field_declare3 = ''
    field_declare4 = ''
    field_declare5 = ''
    field_assign1 = ''
    field_assign2 = ''
    field_assign3 = ''
    field_assign5 = ''
    declare_if_logic_in = ''
    declare_if_logic_out = ''
    declare_if_mdpt_in = ''
    declare_if_mdpt_out = ''
    declare_if_mdpt_in_again = ''
    declare_if_mdpt_out_again = ''
    field_inst = ''
    pre_msb = 0
    rsv_cnt = 0
    reg_write = 'reg_write'
    for field in reg_list:
        field_up_signal = ''
        field_up_en_signal = ''
        f_name = field[0]
        f_offset = int(field[1]) % reg_dw
        f_width = int(field[2])
        f_init = field[4].replace("0x", "'h")
        f_rw = field[3]
        reg_write = 'reg_write'
        if f_rw in ['RU']:
            reg_write = '1\'b0'
        if f_rw not in {'WO'}:
            field_assign3 += 'assign f_{}_rd = r_reg_out_rd;\n'.format(f_name)
        if f_rw not in {'RW', 'WO'}:
            declare_if_mdpt_in += '                     output {}_in,\n'.format(f_name)
            declare_if_mdpt_in_again += '                     input {}_in,\n'.format(f_name)
        if f_rw not in {'WO'}:
            declare_if_mdpt_out += '                        input {}_rd,\n'.format(f_name)
            declare_if_mdpt_out_again += '                        output {}_rd,\n'.format(f_name)
            declare_if_logic_out += 'logic             {}_rd;\n'.format(f_name)
        if f_rw not in {'RO', 'RC', 'RU'}:
            if f_rw in['RWHW']:
                field_assign3 += 'assign f_{}_wr = r_reg_out_wr | f_{}_up_en_r;\n'.format(f_name,f_name)
                field_assign5 += '''
always @(posedge clk or negedge rst_n)
    if(!rst_n) begin
        f_{}_up_en_r <= 0;
    end
    else begin
        f_{}_up_en_r <= f_{}_up_en;
    end
                '''.format(f_name,f_name,f_name)
            else:
                field_assign3 += 'assign f_{}_wr = r_reg_out_wr;\n'.format(f_name)
            declare_if_logic_out += 'logic             {}_wr;\n'.format(f_name)
            declare_if_mdpt_out += '                        input {}_wr,\n'.format(f_name)
            declare_if_mdpt_out_again += '                        output {}_wr,\n'.format(f_name)
        if pre_msb != f_offset:
            rsv_assign += "assign rsv_{}={}'h0;\n".format(rsv_cnt, f_offset - pre_msb)
            if (f_offset - pre_msb) == 1:
                field_declare1 += 'wire        rsv_{};\n'.format(rsv_cnt)
                field_assign2 += 'assign reg_rd_[{}] = rsv_{};\n'.format(pre_msb, rsv_cnt)
            else:
                field_declare1 += 'wire [{}:0] rsv_{};\n'.format(str(f_offset - pre_msb - 1).rjust(2), rsv_cnt)
                field_assign2 += 'assign reg_rd_[{}:{}] = rsv_{};\n'.format(f_offset - 1, pre_msb, rsv_cnt)
        if f_width == 1:
            field_declare1 += 'wire        f_{};\n'.format(f_name)
            field_declare2 += 'wire        f_rd_{};\n'.format(f_name)
            if f_rw in ['RWHW']:
                field_declare5 += 'reg      f_{}_up_en_r;\n'.format(f_name)
            if f_rw not in ['RO', 'RC']:
                field_assign1 += 'assign f_{_f_name}_out = f_{_f_name};\n'.format(_f_name=f_name)
            field_assign2 += 'assign reg_rd_[{}] = f_rd_{};\n'.format(f_offset, f_name)
            if f_rw not in ['RW', 'WO']:
                declare_if_logic_in += 'logic             {}_in;\n'.format(f_name)
            if f_rw not in ['RW', 'WO']:
                field_declare3 += 'input                       f_{}_up_data,\n        '.format(f_name)
            if f_rw not in ['RO', 'RC']:
                if f_rw not in ['RW', 'WO']:
                    declare_if_logic_in += 'logic             {}_wen;\n'.format(f_name)
                    declare_if_mdpt_in += '                     output {}_wen,\n'.format(f_name)
                    declare_if_mdpt_in_again += '                     input {}_wen,\n'.format(f_name)
                declare_if_logic_out += 'logic             {}_out;\n'.format(f_name)
                declare_if_mdpt_out += '                        input {}_out,\n'.format(f_name)
                declare_if_mdpt_out_again += '                        output {}_out,\n'.format(f_name)
                if f_rw not in ['RW', 'WO']:
                    field_declare3 += 'input                       f_{}_up_en,\n        '.format(f_name)
                    field_up_signal += 'f_{_f_name}_up_data'.format(_f_name=f_name)
                    field_up_en_signal += 'f_{_f_name}_up_en'.format(_f_name=f_name)
                else:
                    field_up_signal += '''{}'b0'''.format(f_width)
                    field_up_en_signal += "1'b0"
                field_declare4 += 'output                      f_{}_out,\n        '.format(f_name)
                if f_rw not in {'WO'}:
                    field_declare4 += 'output                      f_{}_rd,\n        '.format(f_name)
                if f_rw not in ['RC', 'RU']:
                    field_declare4 += 'output                      f_{}_wr,\n        '.format(f_name)
                field_inst += '''
field_common 
    #(
        .FIELD_ACCESS("{_f_rw}"), 
        .FIELD_DEFAULT(1{_f_init})
     ) u_f_{_f_name} 
    (
        .clk          ( clk             ), 
        .rst_n        ( rst_n           ),
        .field_up_en  ( {_field_up_en_signal}   ),
        .field_up     ( {_field_up_signal} ),
        .field_wr_en  ( {_reg_write}       ),
        .field_wr     ( reg_wr_data[{_f_offset}] ),
        .field_rd_en  ( reg_read        ),
        .field_rd_out ( f_rd_{_f_name}    ),
        .field_out    ( f_{_f_name} )
    );'''.format(_f_rw=f_rw, _f_init=f_init, _f_name=f_name, _f_offset=str(f_offset).rjust(2),
                 _field_up_en_signal=field_up_en_signal, _field_up_signal=field_up_signal, _reg_write=reg_write)
            else:
                field_declare4 += 'output                      f_{}_rd,\n        '.format(f_name)
                field_inst += '''
field_ro 
    #(
     ) u_f_{_f_name} 
    (
        .field_up     ( f_{_f_name}_up_data ),
        .field_rd_out ( f_{_f_name}    ),
        .field_out    ( f_rd_{_f_name} )
    );'''.format(_f_name=f_name, _f_offset=str(f_offset).rjust(2))

        else:
            reg_write = 'reg_write'
            if f_rw in ['RU']:
                reg_write = '1\'b0'
            field_declare1 += 'wire [{}:0] f_{};\n'.format(str(f_width - 1).rjust(2), f_name)
            field_declare2 += 'wire [{}:0] f_rd_{};\n'.format(str(f_width - 1).rjust(2), f_name)
            if f_rw in ['RWHW']:
                field_declare5 += 'reg [{}:0] f_{}_up_en_r;\n'.format(str(f_width - 1).rjust(2), f_name)
            if f_rw not in ['RO', 'RC']:
                field_assign1 += 'assign f_{_f_name}_out = f_{_f_name};\n'.format(_f_name=f_name)
            field_assign2 += 'assign reg_rd_[{}:{}] = f_rd_{};\n'.format(f_width + f_offset - 1, f_offset, f_name)
            if f_rw not in ['RW', 'WO']:
                declare_if_logic_in += 'logic[{}:0]         {}_in;\n'.format(str(f_width - 1).rjust(2), f_name)
            if f_rw not in ['RW', 'WO']:
                field_declare3 += 'input[{}:0]                 f_{}_up_data,\n        '.format(
                    str(f_width - 1).rjust(2), f_name)
            if f_rw not in ['RO', 'RC']:
                if f_rw not in ['RW', 'WO']:
                    declare_if_logic_in += 'logic             {}_wen;\n'.format(f_name)
                    declare_if_mdpt_in += '                     output {}_wen,\n'.format(f_name)
                    declare_if_mdpt_in_again += '                     input {}_wen,\n'.format(f_name)
                declare_if_logic_out += 'logic[{}:0]       {}_out;\n'.format(str(f_width - 1).rjust(2), f_name)
                declare_if_mdpt_out += '                        input {}_out,\n'.format(f_name)
                declare_if_mdpt_out_again += '                        output {}_out,\n'.format(f_name)
                if f_rw not in ['RW', 'WO']:
                    field_declare3 += 'input                       f_{}_up_en,\n        '.format(f_name)
                    field_up_signal += 'f_{_f_name}_up_data'.format(_f_name=f_name)
                    field_up_en_signal += 'f_{_f_name}_up_en'.format(_f_name=f_name)
                else:
                    field_up_signal += '''{}'b0'''.format(f_width)
                    field_up_en_signal += "1'b0"
                field_declare4 += 'output[{}:0]                f_{}_out,\n        '.format(str(f_width - 1).rjust(2),
                                                                                           f_name)
                if f_rw not in {'WO'}:
                    field_declare4 += 'output                      f_{}_rd,\n        '.format(f_name)
                if f_rw not in ['RC', 'RU']:
                    field_declare4 += 'output                      f_{}_wr,\n        '.format(f_name)
                field_inst += '''
field_common 
    #(
        .FIELD_WIDTH({_f_width}), 
        .FIELD_ACCESS("{_f_rw}"), 
        .FIELD_DEFAULT({_f_width}{_f_init})
     ) u_f_{_f_name} 
    (
        .clk          ( clk                ), 
        .rst_n        ( rst_n              ),
        .field_up_en  ( {_field_up_en_signal} ),
        .field_up     ( {_field_up_signal} ),
        .field_wr_en  ( {_reg_write}          ),
        .field_wr     ( reg_wr_data[{_f_msb}:{_f_offset}] ),
        .field_rd_en  ( reg_read           ),
        .field_rd_out ( f_rd_{_f_name}    ),
        .field_out    ( f_{_f_name} )
    );'''.format(_f_width=f_width, _f_rw=f_rw, _f_init=f_init, _f_name=f_name, _f_offset=str(f_offset).rjust(2),
                 _f_msb=str(f_width + f_offset - 1).rjust(2), _field_up_en_signal=field_up_en_signal,
                 _field_up_signal=field_up_signal, _reg_write=reg_write)
            else:
                field_declare4 += 'output                    f_{}_rd,\n        '.format(f_name)
                field_inst += '''
field_ro 
    #(
        .FIELD_WIDTH({_f_width}) 
     ) u_f_{_f_name} 
    (
        .field_up     ( f_{_f_name}_up_data ),
        .field_rd_out ( f_{_f_name}    ),
        .field_out    ( f_rd_{_f_name} )
    );'''.format(_f_width=f_width, _f_name=f_name, _f_offset=str(f_offset).rjust(2),
                 _f_msb=str(f_width + f_offset - 1).rjust(2))

        pre_msb = f_offset + f_width
        rsv_cnt += 1
    if pre_msb != reg_dw:
        rsv_assign += "assign rsv_{}={}'h0;\n".format(rsv_cnt, reg_dw - pre_msb)
        if reg_dw - pre_msb == 1:
            field_declare1 += 'wire        rsv_{};\n'.format(rsv_cnt)
            field_assign2 += 'assign reg_rd_[{}] = rsv_{};\n'.format(pre_msb, rsv_cnt)
        else:
            field_declare1 += 'wire [{}:0] rsv_{};\n'.format(str(reg_dw - pre_msb - 1).rjust(2), rsv_cnt)
            field_assign2 += 'assign reg_rd_[{}:{}] = rsv_{};\n'.format(reg_dw - 1, pre_msb, rsv_cnt)
    context = '''//=========================================================
//File name    : reg_{_name}.v
//Author       : Heterogeneous Computing Group
//Module name  : reg_{_name}
//Discribution : register description
//Date         : {_curr_time}
//=========================================================
`ifndef REG_{_Ubn}_{_Uname}__SV
`define REG_{_Ubn}_{_Uname}__SV

module reg_{_bn}_{_name}
    #(
        parameter REG_WIDTH = {_r_width}
     )
    (
        input                       clk        ,
        input                       rst_n      ,

        {_field_declare3}
        {_field_declare4}
        input                       reg_wr_sel ,
        input                       reg_wr_rd  ,//1: write; 0: read
        input       [REG_WIDTH-1:0] reg_wr_data,
        output wire [REG_WIDTH-1:0] reg_rd_out 
    );

//register declare
wire [REG_WIDTH-1:0] reg_rd_;
wire reg_write;
wire reg_read;
reg r_reg_out_wr;
reg r_reg_out_rd;
//field declare
{_field_declare1}
//field read declare
{_field_declare2}
//field hw up declare
{_field_declare5}

assign reg_write = reg_wr_sel==1'b1 && reg_wr_rd==1'b1;
assign reg_read  = reg_wr_sel==1'b1 && reg_wr_rd==1'b0;

{_field_assign3}
{_field_assign5}

always @(posedge clk or negedge rst_n)
    if(!rst_n) begin
        r_reg_out_wr <= 0;
        r_reg_out_rd <= 0;
    end
    else begin
        r_reg_out_wr <= reg_write;
        r_reg_out_rd <= reg_read;
    end
//reserved tie 0
{_rsv_assign}
//field instance
{_field_inst}

//register output
{_field_assign1}
{_field_assign2}
assign reg_rd_out = reg_rd_;

endmodule

`endif
'''.format(_curr_time=curr_time, _bn=subblock_name, _name=reg_name, _Ubn=subblock_name.upper(), _Uname=reg_name.upper(),
           _r_width=reg_dw,
           _field_declare1=field_declare1, _field_declare2=field_declare2, _field_declare5=field_declare5, _field_declare3=field_declare3,
           _field_declare4=field_declare4, _rsv_assign=rsv_assign, _field_inst=field_inst, _field_assign1=field_assign1,
           _field_assign2=field_assign2, _field_assign3=field_assign3, _field_assign5=field_assign5)
    gen_file(file_path, file_name, context)
    return declare_if_logic_in, declare_if_logic_out, declare_if_mdpt_in, declare_if_mdpt_out, \
           declare_if_mdpt_in_again, declare_if_mdpt_out_again

def gen_tmp_sub_reg(b_name, r_name, addr_w, r_offset, reg_list):
    reg_if_inst = ''
    for field in reg_list:
        f_name = field[0]
        f_rw = field[3]
        if f_rw not in ['RW', 'WO']:
            reg_if_inst += '        .f_{_f_name}_up_data({_b_name}_if_regs.f_{_r_name}_{_f_name}_in),\n'.format(
                _f_name=f_name,
                _b_name=b_name,
                _r_name=r_name)
        if f_rw not in ['RO', 'RC']:
            if f_rw not in ['RW', 'WO']:
                reg_if_inst += '        .f_{_f_name}_up_en({_b_name}_if_regs.f_{_r_name}_{_f_name}_vld),\n'.format(
                    _f_name=f_name,
                    _b_name=b_name,
                    _r_name=r_name)
            reg_if_inst += '        .f_{_f_name}_out({_b_name}_if_regs.f_{_r_name}_{_f_name}_out),\n'.format(
                    _f_name=f_name,
                    _b_name=b_name,
                    _r_name=r_name)
        if f_rw not in ['RO', 'RC', 'RU']:
            reg_if_inst += '        .f_{_f_name}_wr({_b_name}_if_regs.f_{_r_name}_{_f_name}_wr),\n'.format(
                _f_name=f_name,
                _b_name=b_name,
                _r_name=r_name)
        if f_rw not in ['WO']:
            reg_if_inst += '        .f_{_f_name}_rd({_b_name}_if_regs.f_{_r_name}_{_f_name}_rd),\n'.format(
                _f_name=f_name,
                _b_name=b_name,
                _r_name=r_name)
    reg_inner_declare = '        input       [REG_WIDTH:0] ' + 'reg_{}_up'.format(r_name).ljust(30) + ',\n'
    reg_inner_output = '        output wire [REG_WIDTH-1:0] ' + 'reg_{}_out'.format(r_name).ljust(30) + ',\n'
    reg_sel_declare = 'wire ' + 'reg_{}_sel'.format(r_name).ljust(30) + ';\n'
    reg_sel_assign = "assign " + "reg_{}_sel".format(r_name).ljust(
        30) + " = {}_if_slave.wr_sel==1'b1 && {}_if_slave.wr_addr=='h{};\n".format(b_name, b_name, r_offset)
    reg_rd_declare = 'wire[REG_WIDTH-1:0] ' + 'reg_{}_rd_out'.format(r_name).ljust(30) + ';\n'
    reg_rd_connect = "            'h{} : rd_data_reg = ".format(r_offset) + 'reg_{}_rd_out'.format(
        r_name).ljust(30) + ';\n'
    reg_instance = '''reg_{_bn}_{_name}
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_{_name}
    (
        .clk         ( {_b_name}_if_slave.clk   ), 
        .rst_n       ( {_b_name}_if_slave.rst_n ),
{_reg_if_inst}
        .reg_wr_sel  ( reg_{_name}_sel ),
        .reg_wr_rd   ( {_b_name}_if_slave.wr_rd   ),
        .reg_wr_data ( {_b_name}_if_slave.wr_data ),
        .reg_rd_out  ( reg_{_name}_rd_out )             
    );
'''.format(_bn=b_name, _name=r_name, _b_name=b_name, _reg_if_inst=reg_if_inst)
    return reg_inner_declare, reg_inner_output, reg_sel_declare, reg_sel_assign, reg_rd_declare, \
           reg_rd_connect, reg_instance

def gen_tmp_sub_reg2(b_name, r_name, addr_w, r_offset, reg_list):
    reg_if_inst = ''
    for field in reg_list:
        f_name = field[0]
        f_rw = field[3]
        if f_rw not in ['RW', 'WO']:
            reg_if_inst += '        .f_{_f_name}_up_data({_b_name}_if_regs.{_f_name}_in),\n'.format(
                _f_name=f_name,
                _b_name=b_name,
                _r_name=r_name)
        if f_rw not in ['RO', 'RC']:
            if f_rw not in ['RW', 'WO']:
                reg_if_inst += '        .f_{_f_name}_up_en({_b_name}_if_regs.{_f_name}_wen),\n'.format(
                    _f_name=f_name,
                    _b_name=b_name,
                    _r_name=r_name)
            reg_if_inst += '        .f_{_f_name}_out({_b_name}_if_regs.{_f_name}_out),\n'.format(
                    _f_name=f_name,
                    _b_name=b_name,
                    _r_name=r_name)
        if f_rw not in ['RO', 'RC', 'RU']:
            reg_if_inst += '        .f_{_f_name}_wr({_b_name}_if_regs.{_f_name}_wr),\n'.format(
                _f_name=f_name,
                _b_name=b_name,
                _r_name=r_name)
        if f_rw not in ['WO']:
            reg_if_inst += '        .f_{_f_name}_rd({_b_name}_if_regs.{_f_name}_rd),\n'.format(
                _f_name=f_name,
                _b_name=b_name,
                _r_name=r_name)
    reg_inner_declare = '        input       [REG_WIDTH:0] ' + 'reg_{}_up'.format(r_name).ljust(30) + ',\n'
    reg_inner_output = '        output wire [REG_WIDTH-1:0] ' + 'reg_{}_out'.format(r_name).ljust(30) + ',\n'
    reg_sel_declare = 'wire ' + 'reg_{}_sel'.format(r_name).ljust(30) + ';\n'
    reg_sel_assign = "assign " + "reg_{}_sel".format(r_name).ljust(
        30) + " = {}_if_slave.wr_sel==1'b1 && {}_if_slave.wr_addr=='h{};\n".format(b_name, b_name, r_offset)
    reg_rd_declare = 'wire[REG_WIDTH-1:0] ' + 'reg_{}_rd_out'.format(r_name).ljust(30) + ';\n'
    reg_rd_connect = "            'h{} : rd_data_reg = ".format(r_offset) + 'reg_{}_rd_out'.format(
        r_name).ljust(30) + ';\n'
    reg_instance = '''reg_{_bn}_{_name}
    #(
        .REG_WIDTH(REG_WIDTH)
     ) u_r_{_name}
    (
        .clk         ( {_b_name}_if_slave.clk   ), 
        .rst_n       ( {_b_name}_if_slave.rst_n ),
{_reg_if_inst}
        .reg_wr_sel  ( reg_{_name}_sel ),
        .reg_wr_rd   ( {_b_name}_if_slave.wr_rd   ),
        .reg_wr_data ( {_b_name}_if_slave.wr_data ),
        .reg_rd_out  ( reg_{_name}_rd_out )             
    );
'''.format(_bn=b_name, _name=r_name, _b_name=b_name, _reg_if_inst=reg_if_inst)
    return reg_inner_declare, reg_inner_output, reg_sel_declare, reg_sel_assign, reg_rd_declare, \
           reg_rd_connect, reg_instance

def gen_tmp_sub_if(b_name, r_name, addr_w, r_offset):
    reg_inner_declare = '       logic                       ' + 'reg_{}_in_vld'.format(r_name).ljust(30) + ';\n'
    reg_inner_declare += '       logic       [REG_WIDTH-1:0] ' + 'reg_{}_in'.format(r_name).ljust(30) + ';\n'
    reg_inner_output = '        logic                       ' + 'reg_{}_out_wr'.format(r_name).ljust(30) + ';\n'
    reg_inner_output += '        logic                       ' + 'reg_{}_out_rd'.format(r_name).ljust(30) + ';\n'
    reg_inner_output += '        logic       [REG_WIDTH-1:0] ' + 'reg_{}_out'.format(r_name).ljust(30) + ';\n'
    reg_inner_declare_modport = '\t' * 6 + 'output ' + 'reg_{}_in_vld'.format(r_name).ljust(30) + ',\n'
    reg_inner_declare_modport += '\t' * 6 + 'output ' + 'reg_{}_in'.format(r_name).ljust(30) + ',\n'
    reg_inner_output_modport = '\t' * 6 + 'input ' + 'reg_{}_out_wr'.format(r_name).ljust(30) + ',\n'
    reg_inner_output_modport += '\t' * 6 + 'input ' + 'reg_{}_out_rd'.format(r_name).ljust(30) + ',\n'
    reg_inner_output_modport += '\t' * 6 + 'input ' + 'reg_{}_out'.format(r_name).ljust(30) + ',\n'
    return reg_inner_declare, reg_inner_output, reg_inner_declare_modport, reg_inner_output_modport


def gen_sub_reg(project_list, subblock_name, subblock_size, subblock_dw, subblock_list):
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    file_path = './register_v/{_name}'.format(_name=subblock_name)
    file_name = 'sub_{_name}_reg.v'.format(_name=subblock_name)
    sub_size = int(re.sub(r'\D', '', subblock_size))
    addr_w = 8
    # project_dw = project_list[2]
    for i in range(64):
        if 2 ** i == sub_size:
            addr_w = i
            break
    reg_inner_declare = ''
    reg_inner_output = ''
    reg_sel_declare, reg_sel_assign = '', ''
    reg_rd_declare = ''
    reg_rd_connect = ''
    reg_instance = ''
    for reg in subblock_list:
        r_name = reg[0]
        r_offset = reg[1].replace('0x', '')
        r_type = reg[2]
        r_depth = reg[3]
        r_width = reg[4]
        reg_list = reg[5]
        # r_rw = 'RO'
        if r_type != 'memory':
            if r_depth == 1:
                if subblock_dw == r_width:
                    tmp_sub = gen_tmp_sub_reg(subblock_name, r_name, addr_w, r_offset, reg_list)
                    reg_inner_declare += tmp_sub[0]
                    reg_inner_output += tmp_sub[1]
                    reg_sel_declare += tmp_sub[2]
                    reg_sel_assign += tmp_sub[3]
                    reg_rd_declare += tmp_sub[4]
                    reg_rd_connect += tmp_sub[5]
                    reg_instance += tmp_sub[6]
                else:
                    reg_num = math.ceil(r_width / subblock_dw)
                    tmp_offset = r_offset
                    for i in range(reg_num):
                        tmp_field_list = [field for field in reg_list if
                                          int(field[1]) >= i * subblock_dw and int(field[1]) < (
                                                  i + 1) * subblock_dw]
                        tmp_sub = gen_tmp_sub_reg(subblock_name,
                                                  "{}_{}_{}".format(r_name, i * subblock_dw, (i + 1) * subblock_dw - 1),
                                                  addr_w, tmp_offset, tmp_field_list)
                        reg_inner_declare += tmp_sub[0]
                        reg_inner_output += tmp_sub[1]
                        reg_sel_declare += tmp_sub[2]
                        reg_sel_assign += tmp_sub[3]
                        reg_rd_declare += tmp_sub[4]
                        reg_rd_connect += tmp_sub[5]
                        reg_instance += tmp_sub[6]
                        tmp_offset = str(hex(int('0x' + tmp_offset, 16) + math.ceil(subblock_dw / 8))).replace(
                            '0x', '')
            else:
                for reg_i in range(r_depth):
                    tmp_offset = r_offset
                    if subblock_dw == r_width:
                        tmp_sub = gen_tmp_sub_reg(subblock_name, "{}{}".format(r_name, reg_i), addr_w, tmp_offset,
                                                  reg_list)
                        reg_inner_declare += tmp_sub[0]
                        reg_inner_output += tmp_sub[1]
                        reg_sel_declare += tmp_sub[2]
                        reg_sel_assign += tmp_sub[3]
                        reg_rd_declare += tmp_sub[4]
                        reg_rd_connect += tmp_sub[5]
                        reg_instance += tmp_sub[6]
                        tmp_offset = str(hex(int('0x' + tmp_offset, 16) + math.ceil(subblock_dw / 8))).replace(
                            '0x', '')
                    else:
                        reg_num = math.ceil(r_width / subblock_dw)
                        for i in range(reg_num):
                            tmp_field_list = [field for field in reg_list if
                                              int(field[1]) >= i * subblock_dw and int(field[1]) < (
                                                      i + 1) * subblock_dw]
                            tmp_sub = gen_tmp_sub_reg(subblock_name, "{}{}_{}_{}".format(r_name, reg_i, i * subblock_dw,
                                                                                         (i + 1) * subblock_dw - 1),
                                                      addr_w, tmp_offset, tmp_field_list)
                            reg_inner_declare += tmp_sub[0]
                            reg_inner_output += tmp_sub[1]
                            reg_sel_declare += tmp_sub[2]
                            reg_sel_assign += tmp_sub[3]
                            reg_rd_declare += tmp_sub[4]
                            reg_rd_connect += tmp_sub[5]
                            reg_instance += tmp_sub[6]
                            tmp_offset = str(
                                hex(int('0x' + tmp_offset, 16) + math.ceil(subblock_dw / 8))).replace('0x', '')
        else:
            reg_inner_declare += "        //--may declare a memory up input for {}\n".format(r_name)
            reg_inner_output += "        //--may declare a memory outpput for {}\n".format(r_name)
            reg_sel_declare += "//--may declare a memory select for {}\n".format(r_name)
            reg_sel_assign += "//--may declare a memory selection assignment for {}\n".format(r_name)
            reg_rd_declare += "//--may declare a memory read out signal for {}\n".format(r_name)
            reg_rd_connect += "            //--may declare a memory read out connect for {}\n".format(r_name)
            reg_instance += "//--may declare a memory instance for {}\n".format(r_name)
    context = '''//=========================================================
//File name    : sub_{_name}_reg.v
//Author       : Heterogeneous Computing Group
//Module name  : sub_{_name}_reg
//Discribution : sub-block register description
//Date         : {_curr_time}
//=========================================================
`ifndef SUB_{_Uname}_REG__SV
`define SUB_{_Uname}_REG__SV

module sub_{_name}_reg
    #(
        parameter REG_WIDTH = {_r_width},
        parameter ADDR_WIDTH = {_a_width}
     )
    (  
        sub_{_name}_if.SLAVE {_name}_if_slave,
        sub_{_name}_if.REGS {_name}_if_regs        
    );

//reg_xx_sel declare
{_reg_sel_declare}
//reg_xx_rd declare
{_reg_rd_declare}

reg [REG_WIDTH-1:0] rd_data_reg;

//reg_xx_sel assignment
{_reg_sel_assign}

//reg instance
{_reg_instance}

//rd_data case
//always @(posedge {_name}_if_slave.clk or {_name}_if_slave.rst_n) begin
//    if({_name}_if_slave.rst_n==1'b0) begin
//        rd_data_reg = {{REG_WIDTH{{1'b0}}}};
//    end
//    else if({_name}_if_slave.wr_sel==1'b1 && {_name}_if_slave.wr_rd==1'b0) begin
//    end
//end
always @(*) begin
    if({_name}_if_slave.wr_sel==1'b1 && {_name}_if_slave.wr_rd==1'b0) begin
        case({_name}_if_slave.wr_addr)
{_reg_rd_connect}
            default : rd_data_reg = 'habadbeef;
        endcase
    end
    else begin
        rd_data_reg = {{REG_WIDTH{{1'b0}}}};
    end
end
assign {_name}_if_slave.rd_data = rd_data_reg;

endmodule

`endif
'''.format(_curr_time=curr_time, _name=subblock_name, _Uname=subblock_name.upper(), _r_width=subblock_dw,
           _a_width=addr_w, \
           _reg_inner_declare=reg_inner_declare, _reg_inner_output=reg_inner_output, _reg_sel_declare=reg_sel_declare, \
           _reg_rd_declare=reg_rd_declare, _reg_sel_assign=reg_sel_assign, _reg_instance=reg_instance,
           _reg_rd_connect=reg_rd_connect)
    gen_file(file_path, file_name, context)

def gen_sub_reg2(project_list, subblock_name, subblock_size, subblock_dw, subblock_list):
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    file_path = './register_v/{_name}'.format(_name=subblock_name)
    file_name = 'sub_{_name}_reg.v'.format(_name=subblock_name)
    sub_size = int(re.sub(r'\D', '', subblock_size))
    addr_w = 8
    # project_dw = project_list[2]
    for i in range(64):
        if 2 ** i == sub_size:
            addr_w = i
            break
    reg_inner_declare = ''
    reg_inner_output = ''
    reg_sel_declare, reg_sel_assign = '', ''
    reg_rd_declare = ''
    reg_rd_connect = ''
    reg_instance = ''
    for reg in subblock_list:
        r_name = reg[0]
        r_offset = reg[1].replace('0x', '')
        r_type = reg[2]
        r_depth = reg[3]
        r_width = reg[4]
        reg_list = reg[5]
        # r_rw = 'RO'
        if r_type != 'memory':
            if r_depth == 1:
                if subblock_dw == r_width:
                    tmp_sub = gen_tmp_sub_reg2(subblock_name, r_name, addr_w, r_offset, reg_list)
                    reg_inner_declare += tmp_sub[0]
                    reg_inner_output += tmp_sub[1]
                    reg_sel_declare += tmp_sub[2]
                    reg_sel_assign += tmp_sub[3]
                    reg_rd_declare += tmp_sub[4]
                    reg_rd_connect += tmp_sub[5]
                    reg_instance += tmp_sub[6]
                else:
                    reg_num = math.ceil(r_width / subblock_dw)
                    tmp_offset = r_offset
                    for i in range(reg_num):
                        tmp_field_list = [field for field in reg_list if
                                          int(field[1]) >= i * subblock_dw and int(field[1]) < (
                                                  i + 1) * subblock_dw]
                        tmp_sub = gen_tmp_sub_reg2(subblock_name,
                                                  "{}_{}_{}".format(r_name, i * subblock_dw, (i + 1) * subblock_dw - 1),
                                                  addr_w, tmp_offset, tmp_field_list)
                        reg_inner_declare += tmp_sub[0]
                        reg_inner_output += tmp_sub[1]
                        reg_sel_declare += tmp_sub[2]
                        reg_sel_assign += tmp_sub[3]
                        reg_rd_declare += tmp_sub[4]
                        reg_rd_connect += tmp_sub[5]
                        reg_instance += tmp_sub[6]
                        tmp_offset = str(hex(int('0x' + tmp_offset, 16) + math.ceil(subblock_dw / 8))).replace(
                            '0x', '')
            else:
                for reg_i in range(r_depth):
                    tmp_offset = r_offset
                    if subblock_dw == r_width:
                        tmp_sub = gen_tmp_sub_reg2(subblock_name, "{}{}".format(r_name, reg_i), addr_w, tmp_offset,
                                                  reg_list)
                        reg_inner_declare += tmp_sub[0]
                        reg_inner_output += tmp_sub[1]
                        reg_sel_declare += tmp_sub[2]
                        reg_sel_assign += tmp_sub[3]
                        reg_rd_declare += tmp_sub[4]
                        reg_rd_connect += tmp_sub[5]
                        reg_instance += tmp_sub[6]
                        tmp_offset = str(hex(int('0x' + tmp_offset, 16) + math.ceil(subblock_dw / 8))).replace(
                            '0x', '')
                    else:
                        reg_num = math.ceil(r_width / subblock_dw)
                        for i in range(reg_num):
                            tmp_field_list = [field for field in reg_list if
                                              int(field[1]) >= i * subblock_dw and int(field[1]) < (
                                                      i + 1) * subblock_dw]
                            tmp_sub = gen_tmp_sub_reg2(subblock_name, "{}{}_{}_{}".format(r_name, reg_i, i * subblock_dw,
                                                                                         (i + 1) * subblock_dw - 1),
                                                      addr_w, tmp_offset, tmp_field_list)
                            reg_inner_declare += tmp_sub[0]
                            reg_inner_output += tmp_sub[1]
                            reg_sel_declare += tmp_sub[2]
                            reg_sel_assign += tmp_sub[3]
                            reg_rd_declare += tmp_sub[4]
                            reg_rd_connect += tmp_sub[5]
                            reg_instance += tmp_sub[6]
                            tmp_offset = str(
                                hex(int('0x' + tmp_offset, 16) + math.ceil(subblock_dw / 8))).replace('0x', '')
        else:
            reg_inner_declare += "        //--may declare a memory up input for {}\n".format(r_name)
            reg_inner_output += "        //--may declare a memory outpput for {}\n".format(r_name)
            reg_sel_declare += "//--may declare a memory select for {}\n".format(r_name)
            reg_sel_assign += "//--may declare a memory selection assignment for {}\n".format(r_name)
            reg_rd_declare += "//--may declare a memory read out signal for {}\n".format(r_name)
            reg_rd_connect += "            //--may declare a memory read out connect for {}\n".format(r_name)
            reg_instance += "//--may declare a memory instance for {}\n".format(r_name)
    context = '''//=========================================================
//File name    : sub_{_name}_reg.v
//Author       : Heterogeneous Computing Group
//Module name  : sub_{_name}_reg
//Discribution : sub-block register description
//Date         : {_curr_time}
//=========================================================
`ifndef SUB_{_Uname}_REG__SV
`define SUB_{_Uname}_REG__SV

module sub_{_name}_reg
    #(
        parameter REG_WIDTH = {_r_width},
        parameter ADDR_WIDTH = {_a_width}
     )
    (  
        sub_{_name}_if.SLAVE {_name}_if_slave,
        sub_{_name}_if.REGS {_name}_if_regs        
    );

//reg_xx_sel declare
{_reg_sel_declare}
//reg_xx_rd declare
{_reg_rd_declare}

reg [REG_WIDTH-1:0] rd_data_reg;

//reg_xx_sel assignment
{_reg_sel_assign}

//reg instance
{_reg_instance}

//rd_data case
//always @(posedge {_name}_if_slave.clk or {_name}_if_slave.rst_n) begin
//    if({_name}_if_slave.rst_n==1'b0) begin
//        rd_data_reg = {{REG_WIDTH{{1'b0}}}};
//    end
//    else if({_name}_if_slave.wr_sel==1'b1 && {_name}_if_slave.wr_rd==1'b0) begin
//    end
//end
always @(*) begin
    if({_name}_if_slave.wr_sel==1'b1 && {_name}_if_slave.wr_rd==1'b0) begin
        case({_name}_if_slave.wr_addr)
{_reg_rd_connect}
            default : rd_data_reg = 'habadbeef;
        endcase
    end
    else begin
        rd_data_reg = {{REG_WIDTH{{1'b0}}}};
    end
end
assign {_name}_if_slave.rd_data = rd_data_reg;

endmodule

`endif
'''.format(_curr_time=curr_time, _name=subblock_name, _Uname=subblock_name.upper(), _r_width=subblock_dw,
           _a_width=addr_w, \
           _reg_inner_declare=reg_inner_declare, _reg_inner_output=reg_inner_output, _reg_sel_declare=reg_sel_declare, \
           _reg_rd_declare=reg_rd_declare, _reg_sel_assign=reg_sel_assign, _reg_instance=reg_instance,
           _reg_rd_connect=reg_rd_connect)
    gen_file(file_path, file_name, context)

def gen_sub_filelist(subblock_name, subblock_dw, subblock_list):
    file_path = './register_v/{_name}'.format(_name=subblock_name)
    file_name = 'sub_{_name}_reg.f'.format(_name=subblock_name)
    if '-path' in sys.argv:
        i = sys.argv.index('-path')
        filelist_path = sys.argv[i + 1]
        filelist_path += '/'
        filelist_path += subblock_name
    else:
        filelist_path = '.'
    reg_list = ''
    for reg in subblock_list:
        r_name = reg[0]
        r_type = reg[2]
        r_depth = reg[3]
        r_width = reg[4]
        if r_type != 'memory':
            if r_depth == 1:
                if subblock_dw == r_width:
                    reg_list += '{}/module/reg_{}_{}.v\n'.format(filelist_path, subblock_name, r_name)
                else:
                    reg_num = math.ceil(r_width / subblock_dw)
                    for i in range(reg_num):
                        reg_list += '{}/module/reg_{}_{}_{}_{}.v\n'.format(filelist_path, subblock_name, r_name,
                                                                           i * subblock_dw,
                                                                           (i + 1) * subblock_dw - 1)
            else:
                for reg_i in range(r_depth):
                    if subblock_dw == r_width:
                        reg_list += '{}/module/reg_{}_{}{}.v\n'.format(filelist_path, subblock_name, r_name, reg_i)
                    else:
                        reg_num = math.ceil(r_width / subblock_dw)
                        for i in range(reg_num):
                            reg_list += '{}/module/reg_{}_{}{}_{}_{}.v\n'.format(filelist_path, subblock_name, r_name,
                                                                                 reg_i,
                                                                                 i * subblock_dw,
                                                                                 (i + 1) * subblock_dw - 1)
    context = '''
{_reg_list}
{_filelist_path}/sub_{_name}_reg.v
{_filelist_path}/sub_{_name}_if.v
'''.format(_reg_list=reg_list, _filelist_path=filelist_path, _name=subblock_name)
    gen_file(file_path, file_name, context)


def gen_sub_reg_if(subblock_name, subblock_size, subblock_dw, if_declare):
    if '-time' in sys.argv:
        curr_time = time.strftime("%Y-%m-%d", time.localtime())
    else:
        curr_time = 'time'
    file_path = './register_v/{_name}'.format(_name=subblock_name)
    file_name = 'sub_{_name}_if.v'.format(_name=subblock_name)
    sub_size = int(re.sub(r'\D', '', subblock_size))
    addr_w = 8
    # project_dw = project_list[2]
    for i in range(64):
        if 2 ** i == sub_size:
            addr_w = i
            break
    reg_inner_declare = if_declare[0]
    reg_inner_output = if_declare[1]
    reg_inner_declare_modport = if_declare[2]
    reg_inner_output_modport = if_declare[3]
    reg_inner_declare_modport_again = if_declare[4]
    reg_inner_output_modport_again = if_declare[5]
    context = '''//=========================================================
//File name    : sub_{_name}_if.v
//Author       : Heterogeneous Computing Group
//Module name  : sub_{_name}_if
//Discribution : sub-block reg-interface description
//Date         : {_curr_time}
//=========================================================
`ifndef SUB_{_Uname}_IF__SV
`define SUB_{_Uname}_IF__SV

interface sub_{_name}_if
    #(
        parameter REG_WIDTH = {_r_width},
        parameter ADDR_WIDTH = {_a_width}
     )
    (
        input bit clk,
        input bit rst_n
    );

        logic                       wr_sel  ;
        logic                       wr_rd   ;//1: write; 0: read
        logic      [ADDR_WIDTH-1:0] wr_addr ;
        logic       [REG_WIDTH-1:0] wr_data ;
        logic       [REG_WIDTH-1:0] rd_data ;

//reg_xx_inner declare
{_reg_inner_declare}
//reg_xx_inner_output declare
{_reg_inner_output}

        modport MASTER(
                        input clk,
                        input rst_n,
                        output wr_sel,
                        output wr_rd,
                        output wr_addr,
                        output wr_data,
                        input rd_data
                        );

        modport SLAVE(
                        input clk,
                        input rst_n,
                        input wr_sel,
                        input wr_rd,
                        input wr_addr,
                        input wr_data,
                        output rd_data
                        );
                                                
        modport USER(
{_reg_inner_declare_modport}
{_reg_inner_output_modport}
                            );
                            
        modport REGS(
{_reg_inner_declare_modport_again}
{_reg_inner_output_modport_again}
                            );
                            
endinterface

`endif
'''.format(_curr_time=curr_time, _name=subblock_name, _Uname=subblock_name.upper(), _r_width=subblock_dw,
           _a_width=addr_w, \
           _reg_inner_declare=reg_inner_declare, _reg_inner_output=reg_inner_output,
           _reg_inner_declare_modport=reg_inner_declare_modport, \
           _reg_inner_output_modport=reg_inner_output_modport[0:-2],
           _reg_inner_declare_modport_again=reg_inner_declare_modport_again,
           _reg_inner_output_modport_again=reg_inner_output_modport_again[0:-2])
    gen_file(file_path, file_name, context)


def gen_common():
    context = ''
    gen_filed_common()
    gen_filed_ro()
    if '-path' in sys.argv:
        i = sys.argv.index('-path')
        filelist_path = sys.argv[i + 1]
        filelist_path += '/common'
    else:
        filelist_path = '.'
    context += '{}/module/field_common.v\n'.format(filelist_path)
    context += '{}/module/field_ro.v'.format(filelist_path)
    gen_file('./register_v/common', 'field_common.f', context)


def xml2v(project_list, block_map_dict, subblock_dict):
    ##file list
    for subblock in subblock_dict.keys():
        gen_sub_filelist(subblock, int(block_map_dict[subblock][2]), subblock_dict[subblock])
    ##field.sv
    ##sub-block reg model
    gen_common()
    for subblock in subblock_dict.keys():
        if os.path.exists('./register_v/{}/module'.format(subblock)):
            shutil.rmtree('./register_v/{}/module'.format(subblock))
        declare_if_logic_in = ''
        declare_if_logic_out = ''
        declare_if_mdpt_in = ''
        declare_if_mdpt_out = ''
        declare_if_mdpt_in_again = ''
        declare_if_mdpt_out_again = ''
        subblock_dw = int(block_map_dict[subblock][2])
        # gen_filed_common(subblock)
        # gen_filed_ro(subblock)
        gen_sub_reg(project_list, subblock, block_map_dict[subblock][3], subblock_dw, subblock_dict[subblock])
        # gen_sub_reg_if(project_list, subblock, block_map_dict[subblock][3], subblock_dw, subblock_dict[subblock])
        for reg in subblock_dict[subblock]:
            r_name = reg[0]
            # r_offset = reg[1].replace('0x', '')
            r_type = reg[2]
            r_depth = reg[3]
            r_width = reg[4]
            # r_rw = 'RO'
            if r_type != 'memory':
                if r_depth == 1:
                    if subblock_dw == r_width:
                        if_declare = gen_reg(subblock, r_name, r_width, reg[5])
                        declare_if_logic_in += if_declare[0]
                        declare_if_logic_out += if_declare[1]
                        declare_if_mdpt_in += if_declare[2]
                        declare_if_mdpt_out += if_declare[3]
                        declare_if_mdpt_in_again += if_declare[4]
                        declare_if_mdpt_out_again += if_declare[5]
                    else:
                        reg_num = math.ceil(r_width / subblock_dw)
                        for i in range(reg_num):
                            tmp_field_list = [field for field in reg[5] if
                                              int(field[1]) >= i * subblock_dw and int(field[1]) < (
                                                      i + 1) * subblock_dw]
                            if_declare = gen_reg(subblock,
                                                 "{}_{}_{}".format(r_name, i * subblock_dw, (i + 1) * subblock_dw - 1),
                                                 subblock_dw, tmp_field_list)
                            declare_if_logic_in += if_declare[0]
                            declare_if_logic_out += if_declare[1]
                            declare_if_mdpt_in += if_declare[2]
                            declare_if_mdpt_out += if_declare[3]
                            declare_if_mdpt_in_again += if_declare[4]
                            declare_if_mdpt_out_again += if_declare[5]
                else:
                    for reg_i in range(r_depth):
                        if subblock_dw == r_width:
                            if_declare = gen_reg(subblock, "{}{}".format(r_name, reg_i), r_width, reg[5])
                            declare_if_logic_in += if_declare[0]
                            declare_if_logic_out += if_declare[1]
                            declare_if_mdpt_in += if_declare[2]
                            declare_if_mdpt_out += if_declare[3]
                            declare_if_mdpt_in_again += if_declare[4]
                            declare_if_mdpt_out_again += if_declare[5]
                        else:
                            if_declare = gen_reg(subblock, "{}{}_{}_{}".format(r_name, reg_i, i * subblock_dw,
                                                                               (i + 1) * subblock_dw - 1),
                                                 r_width, reg[5])
                            declare_if_logic_in += if_declare[0]
                            declare_if_logic_out += if_declare[1]
                            declare_if_mdpt_in += if_declare[2]
                            declare_if_mdpt_out += if_declare[3]
                            declare_if_mdpt_in_again += if_declare[4]
                            declare_if_mdpt_out_again += if_declare[5]
        if_declare = [declare_if_logic_in, declare_if_logic_out, declare_if_mdpt_in, declare_if_mdpt_out,
                      declare_if_mdpt_in_again, declare_if_mdpt_out_again]
        gen_sub_reg_if(subblock, block_map_dict[subblock][3], subblock_dw, if_declare)

def xml2v2(project_list, block_map_dict, subblock_dict):
    ##file list
    for subblock in subblock_dict.keys():
        gen_sub_filelist(subblock, int(block_map_dict[subblock][2]), subblock_dict[subblock])
    ##field.sv
    ##sub-block reg model
    gen_common()
    for subblock in subblock_dict.keys():
        if os.path.exists('./register_v/{}/module'.format(subblock)):
            shutil.rmtree('./register_v/{}/module'.format(subblock))
        declare_if_logic_in = ''
        declare_if_logic_out = ''
        declare_if_mdpt_in = ''
        declare_if_mdpt_out = ''
        declare_if_mdpt_in_again = ''
        declare_if_mdpt_out_again = ''
        subblock_dw = int(block_map_dict[subblock][2])
        # gen_filed_common(subblock)
        # gen_filed_ro(subblock)
        gen_sub_reg2(project_list, subblock, block_map_dict[subblock][3], subblock_dw, subblock_dict[subblock])
        # gen_sub_reg_if2(project_list, subblock, block_map_dict[subblock][3], subblock_dw, subblock_dict[subblock])
        for reg in subblock_dict[subblock]:
            r_name = reg[0]
            # r_offset = reg[1].replace('0x', '')
            r_type = reg[2]
            r_depth = reg[3]
            r_width = reg[4]
            # r_rw = 'RO'
            if r_type != 'memory':
                if r_depth == 1:
                    if subblock_dw == r_width:
                        if_declare = gen_reg2(subblock, r_name, r_width, reg[5])
                        declare_if_logic_in += if_declare[0]
                        declare_if_logic_out += if_declare[1]
                        declare_if_mdpt_in += if_declare[2]
                        declare_if_mdpt_out += if_declare[3]
                        declare_if_mdpt_in_again += if_declare[4]
                        declare_if_mdpt_out_again += if_declare[5]
                    else:
                        reg_num = math.ceil(r_width / subblock_dw)
                        for i in range(reg_num):
                            tmp_field_list = [field for field in reg[5] if
                                              int(field[1]) >= i * subblock_dw and int(field[1]) < (
                                                      i + 1) * subblock_dw]
                            if_declare = gen_reg2(subblock,
                                                 "{}_{}_{}".format(r_name, i * subblock_dw, (i + 1) * subblock_dw - 1),
                                                 subblock_dw, tmp_field_list)
                            declare_if_logic_in += if_declare[0]
                            declare_if_logic_out += if_declare[1]
                            declare_if_mdpt_in += if_declare[2]
                            declare_if_mdpt_out += if_declare[3]
                            declare_if_mdpt_in_again += if_declare[4]
                            declare_if_mdpt_out_again += if_declare[5]
                else:
                    for reg_i in range(r_depth):
                        if subblock_dw == r_width:
                            if_declare = gen_reg2(subblock, "{}{}".format(r_name, reg_i), r_width, reg[5])
                            declare_if_logic_in += if_declare[0]
                            declare_if_logic_out += if_declare[1]
                            declare_if_mdpt_in += if_declare[2]
                            declare_if_mdpt_out += if_declare[3]
                            declare_if_mdpt_in_again += if_declare[4]
                            declare_if_mdpt_out_again += if_declare[5]
                        else:
                            if_declare = gen_reg2(subblock, "{}{}_{}_{}".format(r_name, reg_i, i * subblock_dw,
                                                                               (i + 1) * subblock_dw - 1),
                                                 r_width, reg[5])
                            declare_if_logic_in += if_declare[0]
                            declare_if_logic_out += if_declare[1]
                            declare_if_mdpt_in += if_declare[2]
                            declare_if_mdpt_out += if_declare[3]
                            declare_if_mdpt_in_again += if_declare[4]
                            declare_if_mdpt_out_again += if_declare[5]
        if_declare = [declare_if_logic_in, declare_if_logic_out, declare_if_mdpt_in, declare_if_mdpt_out,
                      declare_if_mdpt_in_again, declare_if_mdpt_out_again]
        gen_sub_reg_if(subblock, block_map_dict[subblock][3], subblock_dw, if_declare)

def xml2header2(project_list, block_map_dict, subblock_dict):
    ##generate c header file
    for subblock in subblock_dict.keys():
        macro_context = ''
        ptr_context = ''
        union_context = ''
        if subblock in block_map_dict.keys():
            subblock_base_addr = hex(int(block_map_dict[subblock][0], 16) + int(block_map_dict[subblock][1], 16))
            macro_context += '#define {}_BASE {}\n\n'.format(subblock.upper(), subblock_base_addr)
            for reg in subblock_dict[subblock]:
                struct_context = ''
                if reg[4] == 32:
                    ptr_context += '#define REG_{_bname_u}_{_rname_u} ((volatile REG_{_bname}_{_rname}_TypeDef *)' \
                                   ' ADDR_{_bname_u}_{_rname_u})\n'.format(_bname_u=subblock.upper(),
                                                                           _rname_u=reg[0].upper(), _bname=subblock,
                                                                           _rname=reg[0])
                    if reg[2] == 'memory':
                        macro_context += '#define ADDR_{}_{} ({}_BASE + {})     //{} depth={}\n'.format(
                            subblock.upper(),
                            reg[0].upper(),
                            subblock.upper(),
                            reg[1], reg[2],
                            hex(reg[3]))
                    else:
                        macro_context += '#define ADDR_{}_{} ({}_BASE + {})\n'.format(
                            subblock.upper(), reg[0].upper(), subblock.upper(), reg[1])
                else:
                    ptr_context += '#define REG_{_bname_u}_{_rname_u}_{_rwidth}B ' \
                                   '((volatile REG_{_bname}_{_rname}_{_rwidth}b_TypeDef *)' \
                                   ' ADDR_{_bname_u}_{_rname_u}_{_rwidth}B)\n'.format(_bname_u=subblock.upper(),
                                                                                      _rname_u=reg[0].upper(),
                                                                                      _bname=subblock,
                                                                                      _rname=reg[0], _rwidth=reg[4])
                    if reg[2] == 'memory':
                        macro_context += '#define ADDR_{}_{}_{}B ({}_BASE + {})     //{} depth={}\n'.format(
                            subblock.upper(), reg[0].upper(), reg[4], subblock.upper(), reg[1], reg[2], hex(reg[3]))
                    else:
                        macro_context += '#define ADDR_{}_{}_{}B ({}_BASE + {})\n'.format(
                            subblock.upper(), reg[0].upper(), reg[4], subblock.upper(), reg[1])
                i = 0
                for field in reg[5]:
                    if field[0] == 'Reserved':
                        field_name = 'reserved' + str(i)
                        i += 1
                    else:
                        field_name = field[0]
                    struct_context += '     uint32_t {} : {};             // {}\n'.format(field_name, field[2],
                                                                                          field[3])
                union_context += 'typedef union {\n'
                union_context += '  struct {\n'
                union_context += struct_context
                union_context += '  } bits;\n'
                if reg[4] == 32:
                    union_context += '  uint32_t regVal;\n'
                else:
                    i = int(reg[4] / 32)
                    union_context += '  struct { \n'
                    for j in range(i):
                        union_context += '      uint32_t regVal_{}-{};\n'.format(j * 32, (j + 1) * 32 - 1)
                    union_context += '  }\n'
                union_context += '} '
                if reg[4] == 32:
                    if reg[2] == 'memory':
                        union_context += 'REG_{}_{}_TypeDef;    //{} depth={}\n\n'.format(subblock, reg[0],
                                                                                          reg[2],
                                                                                          hex(reg[3]))
                    else:
                        union_context += 'REG_{}_{}_TypeDef;\n\n'.format(subblock, reg[0])
                else:
                    if reg[2] == 'memory':
                        union_context += 'REG_{}_{}_{}b_TypeDef;    //{} depth={}\n\n'.format(subblock,
                                                                                              reg[0],
                                                                                              reg[4],
                                                                                              reg[2],
                                                                                              hex(reg[3]))
                    else:
                        union_context += 'REG_{}_{}_{}b_TypeDef;\n\n'.format(subblock,
                                                                             reg[0],
                                                                             reg[4])
        context = '#ifndef _{}_H_\n'.format(subblock.upper())
        context += '#define _{}_H_\n\n'.format(subblock.upper())
        context += macro_context + '\n'
        context += ptr_context + '\n'
        context += union_context + '\n'
        context += '#endif'
        gen_file('./c', subblock + '.h', context)


def xml2header(project_list, block_map_dict, subblock_dict):
    ##generate c header file
    for subblock in subblock_dict.keys():
        macro_context = ''
        ptr_context = ''
        union_context = ''
        if subblock in block_map_dict.keys():
            #subblock_base_addr = hex(int(block_map_dict[subblock][0], 16) + int(block_map_dict[subblock][1], 16))
            subblock_base_addr = int(0)
            macro_context += '#define {}_BASE {}\n\n'.format(subblock.upper(), subblock_base_addr)
            prev_offset = 0
            cur_offset = 0
            reserved_reg_index = 0;
            prev_reg = 0
            for reg in subblock_dict[subblock]:
                # print("aaaaa0: " + str(reg[0]))
                # print("aaaaa1: " + str(reg[1]))
                # print("aaaaa2: " + str(reg[2]))
                # print("aaaaa3: " + str(reg[3]))
                # print("aaaaa4: " + str(reg[4]))
                # print("aaaaa5: " + str(reg[5]))
                struct_context = ''
                if reg[4] == 32:
                    ptr_context += '#define REG_{_bname_u}_{_rname_u} ((volatile REG_{_bname}_{_rname}_TypeDef *)' \
                                   ' ADDR_{_bname_u}_{_rname_u})\n'.format(_bname_u=subblock.upper(),
                                                                           _rname_u=reg[0].upper(), _bname=subblock,
                                                                           _rname=reg[0])
                    if reg[2] == 'memory':
                        macro_context += '#define ADDR_{}_{} ({}_BASE + {})     //{} depth={}\n'.format(
                            subblock.upper(),
                            reg[0].upper(),
                            subblock.upper(),
                            reg[1], reg[2],
                            hex(reg[3]))
                    else:
                        macro_context += '#define ADDR_{}_{} ({}_BASE + {})\n'.format(
                            subblock.upper(), reg[0].upper(), subblock.upper(), reg[1])
                else:
                    ptr_context += '#define REG_{_bname_u}_{_rname_u}_{_rwidth}B ' \
                                   '((volatile REG_{_bname}_{_rname}_{_rwidth}b_TypeDef *)' \
                                   ' ADDR_{_bname_u}_{_rname_u}_{_rwidth}B)\n'.format(_bname_u=subblock.upper(),
                                                                                      _rname_u=reg[0].upper(),
                                                                                      _bname=subblock,
                                                                                      _rname=reg[0], _rwidth=reg[4])
                    if reg[2] == 'memory':
                        macro_context += '#define ADDR_{}_{}_{}B ({}_BASE + {})     //{} depth={}\n'.format(
                            subblock.upper(), reg[0].upper(), reg[4], subblock.upper(), reg[1], reg[2], hex(reg[3]))
                    else:
                        macro_context += '#define ADDR_{}_{}_{}B ({}_BASE + {})\n'.format(
                            subblock.upper(), reg[0].upper(), reg[4], subblock.upper(), reg[1])
                i = 0
                for field in reg[5]:
                    if field[0] == 'Reserved':
                        field_name = 'reserved' + str(i)
                        i += 1
                    else:
                        field_name = field[0]
                    struct_context += '            unsigned int {} : {};             // {}\n'.format(field_name.upper(),
                                                                                                     field[2],
                                                                                                     field[3])
                    # cur_offset = int(reg[1], 16)
                cur_offset = int(reg[1], 16)
                if cur_offset != 0:
                    # To generate reserved bytes/address
                    if ((cur_offset - prev_offset - int(prev_reg) / 8) != 0):
                        union_context += '    unsigned char reserved_reg_' + str(reserved_reg_index) + '[' + str(
                            int((cur_offset - prev_offset - int(int(prev_reg) / 8)))) + ']; \n'

                        reserved_reg_index += 1
                        if ((int((cur_offset - prev_offset - int(int(prev_reg) / 8)))) < 0):
                            # print(reg[0])
                            # print(cur_offset)
                            # print(prev_offset)
                            # print(int(int(prev_reg) / 8))
                            exit()
                        # print(subblock + "----->" + reg[0])
                        # print("warning:-------> " + str(hex(prev_offset)))
                        # print("warning:-------> " + str(hex(cur_offset)))
                        # print("warning:-------> " + str(cur_offset - prev_offset))
                        # print("---------------------------")
                prev_offset = int(reg[1], 16)
                prev_reg = reg[4]
                union_context += '    union {\n'
                union_context += '        struct {\n'
                union_context += struct_context
                union_context += '        } bits;\n'
                if reg[4] == 32:
                    union_context += '        unsigned int regVal;\n'
                else:
                    i = int(reg[4] / 32)
                    union_context += '      struct { \n'
                    for j in range(i):
                        union_context += '          unsigned int regVal_{}_{};\n'.format(j * 32, (j + 1) * 32 - 1)
                    union_context += '      } regVal; \n'
                union_context += '    } '
                if reg[4] == 32:
                    if reg[2] == 'memory':
                        union_context += 'REG_{}_{}_TypeDef;    //{} depth={}\n\n'.format(subblock, reg[0],
                                                                                          reg[2],
                                                                                          hex(reg[3]))
                    else:
                        union_context += '{};\n\n'.format(reg[0].upper())
                else:
                    if reg[2] == 'memory':
                        union_context += 'REG_{}_{}_{}b_TypeDef;    //{} depth={}\n\n'.format(subblock,
                                                                                              reg[0],
                                                                                              reg[4],
                                                                                              reg[2],
                                                                                              hex(reg[3]))
                    else:
                        union_context += '{}_{};\n\n'.format(
                            reg[0].upper(),
                            reg[4])
        context = '#ifndef _{}_H_\n'.format(subblock.upper())
        context += '#define _{}_H_\n\n'.format(subblock.upper())
        context += macro_context + '\n'
        # context += ptr_context + '\n'
        context += "typedef struct {" + "\n"
        context += union_context + '\n'
        context += "} __attribute__((packed)) " + subblock.upper() + "_TypeDef;" + "\n"
        context += "#define " + subblock.upper() + " ((volatile " + subblock.upper() + "_TypeDef" + " *) " + subblock.upper() + "_BASE)" + "\n"
        context += '#endif'
        gen_file('./c', subblock + '.h', context)


def xml2macro(project_list, block_map_dict, subblock_dict):
    ##generate c header file
    for subblock in subblock_dict.keys():
        macro_context = ''
        if subblock in block_map_dict.keys():
            subblock_base_addr = hex(int(block_map_dict[subblock][0], 16) + int(block_map_dict[subblock][1], 16))
            subblock_base_addr_tmp = subblock_base_addr
            subblock_base_addr = '32\'h' + subblock_base_addr.split("x")[-1]
            macro_context += 'parameter {}_BASE = {};\n\n'.format(subblock.upper(), subblock_base_addr)
            for reg in subblock_dict[subblock]:
                reg_absolute_addr = hex(int(subblock_base_addr_tmp, 16) + int(reg[1], 16))
                reg_absolute_addr = '32\'h' + reg_absolute_addr.split("x")[-1]
                reg_offset = '32\'h' + reg[1].split("x")[-1]
                if reg[4] != 32:
                    macro_context += '/*{}*/ `define ADDR_{}_{}_{}B ({}_BASE + {})          //{} depth={}\n'.format(
                        reg_absolute_addr, subblock.upper(), reg[0].upper(), reg[4], subblock.upper(),
                        reg_offset, reg[2], hex(reg[3]))
                else:
                    macro_context += '/*{}*/ `define ADDR_{}_{} ({}_BASE + {})          //{} depth={}\n'.format(
                        reg_absolute_addr, subblock.upper(), reg[0].upper(), subblock.upper(),
                        reg_offset, reg[2], hex(reg[3]))
        context = '`ifndef _{}_MACRO_\n'.format(subblock.upper())
        context += '`define _{}_MACRO_\n\n'.format(subblock.upper())
        context += macro_context + '\n'
        context += '`endif'
        gen_file('./macro', subblock + '_macro.sv', context)


# ===================generate verilog(register  rtl code) end  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
def generate(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved):
    if '-html' in sys.argv:
        if '-resoff' in sys.argv:
            xml2html(tmp_project_list[0], tmp_project_list[1], tmp_block_map_dict, tmp_subblock_dict)
        elif '-chip' in sys.argv:
            xml2html2(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict_incd_reserved)
        else:
            xml2html(tmp_project_list[0], tmp_project_list[1], tmp_block_map_dict, tmp_subblock_dict_incd_reserved)
    if '-sv' in sys.argv:
        xml2sv(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict)
    if '-macro' in sys.argv:
        xml2macro(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict)
    if '-v' in sys.argv:
        if '-ralf' not in sys.argv:
            xml2v(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict)
        else:
            xml2v2(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict)
    if '-c' in sys.argv:
        xml2header(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict_incd_reserved)
    option_list = ['-html', '-sv', '-v', '-c', '-macro']
    if len(list(set(option_list) & set(sys.argv))) == 0:
        if '-resoff' in sys.argv:
            xml2html(tmp_project_list[0], tmp_project_list[1], tmp_block_map_dict, tmp_subblock_dict)
        elif '-chip' in sys.argv:
            xml2html2(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict_incd_reserved)
        else:
            xml2html(tmp_project_list[0], tmp_project_list[1], tmp_block_map_dict, tmp_subblock_dict_incd_reserved)
        xml2sv(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict)
        if '-ralf' not in sys.argv:
            xml2v(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict)
        else:
            xml2v2(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict)
        xml2header(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict_incd_reserved)


# ===========================main <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


if __name__ == "__main__":
    if '-sys' in sys.argv:
        # FILE_NAME = '../desc_xml/merge.xml'
        i = sys.argv.index('-sys')
        file_name = sys.argv[i + 1]
        tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved = paser_xml('sys',
                                                                                                             file_name)
        generate(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved)
    elif '-blk' in sys.argv:
        # i = sys.argv.index('-blk')
        # des_xmls = glob.glob(sys.argv[i + 1] + '/*.xml')
        i = sys.argv.index('-blk')
        file_name = sys.argv[i + 1]
        # des_xmls = glob.glob(os.path.join(sys.argv[i+1],'/*.xml'))
        # for des_xml in des_xmls:
        # file_name = des_xml
        tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved = paser_xml(
            'blk', file_name)
        generate(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved)
    elif '-ipxact' in sys.argv:
        i = sys.argv.index('-ipxact')
        file_name = sys.argv[i + 1]
        tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved = paser_xml(
            'ipxact', file_name)
        generate(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved)
    else:
        FILE_NAME = '../desc_xml/merge.xml'
        tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved = paser_xml('',
                                                                                                             FILE_NAME)
        generate(tmp_project_list, tmp_block_map_dict, tmp_subblock_dict, tmp_subblock_dict_incd_reserved)
