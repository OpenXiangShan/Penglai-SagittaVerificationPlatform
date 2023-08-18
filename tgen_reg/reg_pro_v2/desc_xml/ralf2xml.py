import glob
import os
import sys


from enum import Enum


class estatus(Enum):
    # 为序列值指定value值
    idle = 0
    block_begin = 1
    block_doing = 2
    block_end = 3
    register_begin = 4
    register_doing = 5
    register_end = 6
    field_begin = 7
    field_doing = 8
    field_end = 9
    field_doc_begin = 10
    field_doc_doing = 11
    field_doc_doing_doing = 12
    field_doc_end = 13
    system_begin = 14
    system_doing = 15
    system_end = 16

def l2xml(o_file_name, status, block_name, subblock_reg_list):
    print(block_name,"generate xml")
    xml_contents = []
    xml_contents.append("   <block_map>\n")
    xml_contents.append("       <block_name>{0}</block_name>\n".format(block_name))
    xml_contents.append("       <block_offset>0x0000</block_offset>\n")
    xml_contents.append("       <data_width>{0}bits</data_width>\n".format(subblock_reg_list[0][4]))
    xml_contents.append("       <block_size>4096Bytes</block_size>\n")
    xml_contents.append("   </block_map>\n")
    xml_contents.append("   <subblock>\n")
    xml_contents.append("       <subblock_name>{0}</subblock_name>\n".format(block_name))
    for onereg in subblock_reg_list:
        xml_contents.append("       <register>\n")
        xml_contents.append("           <reg_name>{0}</reg_name>\n".format(onereg[0]))
        xml_contents.append("           <reg_offset>{0}</reg_offset>\n".format(onereg[1]))
        xml_contents.append("           <reg_type>register</reg_type>\n")
        xml_contents.append("           <reg_width>{0}</reg_width>\n".format(onereg[4]))
        for onefield in onereg[5]:
            xml_contents.append("           <field>\n")
            xml_contents.append("               <field_name>{0}</field_name>\n".format(onefield[0]))
            xml_contents.append("               <field_offset>{0}</field_offset>\n".format(onefield[1]))
            xml_contents.append("               <field_width>{0}</field_width>\n".format(onefield[2]))
            xml_contents.append("               <field_access>{0}</field_access>\n".format(onefield[3]))
            xml_contents.append("               <field_init_value>{0}</field_init_value>\n".format(onefield[4]))
            xml_contents.append("               <field_description>{0}</field_description>\n".format(onefield[5]))
            xml_contents.append("           </field>\n")
        xml_contents.append("       </register>\n")
    xml_contents.append("   </subblock>\n")
    if status:
        with open(o_file_name, "w") as file:
            file.write("<all_register>\n")
            for xml_content in xml_contents:
                    file.write(xml_content)
    else:
        with open(o_file_name, "a") as file:
            for xml_content in xml_contents:
                    file.write(xml_content)

def endxmlroot(o_file_name):
    with open(o_file_name, "a") as file:
        file.write("</all_register>\n")

def read_ralf(i_file_name, o_file_name):
    real_block = 1
    status = estatus.idle
    block_name = ''
    block_bytes = ''
    reg_name = ''
    reg_offset = ''
    field_name = ''
    field_offset = ''
    field_width = ''
    field_access = ''
    field_init_value = ''
    field_description = ''
    field_property_list = []
    subblock_reg_list = []
    new_handle = True
    with open(i_file_name, 'r', encoding='utf-8') as hcvg:
        while True:
            line = hcvg.readline()
            if line:
                while True:
                    if line.replace(' ', '').replace('\n', ''):
                        if status == estatus.idle:
                            if "system " in line:
                                line = line.split('system ', 1)[-1]
                                status = estatus.system_begin
                            elif "block" in line:
                                block_name = line.split('block', 1)[-1].replace('\n', '').replace(' ', '')
                                if "{" in block_name:
                                    block_name = block_name.split('{', 1)[0]
                                line = line.split('block', 1)[-1]
                                status = estatus.block_begin
                            else:
                                line = ''
                        elif status == estatus.system_begin:
                            if "{" in line:
                                line = line.split('{', 1)[-1]
                                status = estatus.system_doing
                            else:
                                line = ''
                        elif status == estatus.system_doing:
                            if "}" in line:
                                line = line.split('}', 1)[-1]
                                status = estatus.system_end
                                real_block = 0
                            else:
                                line = ''
                        elif status == estatus.system_end:
                            status = estatus.idle
                            real_block = 0
                        elif status == estatus.block_begin:
                            if "{" in line:
                                line = line.split('{', 1)[-1]
                                status = estatus.block_doing
                            else:
                                line = ''
                        elif status == estatus.block_doing:
                            if "bytes" in line:
                                block_bytes = line.split('bytes', 1)[-1].replace(' ', '').split(';', 1)[0]
                                line = line.split(';', 1)[-1]
                            elif "register" in line:
                                reg_name = line.split('register', 1)[-1].replace(' ', '').split('@', 1)[0]
                                reg_offset = line.split('@', 1)[-1].replace(' ', '').replace('\'h', '0x').split('{', 1)[
                                    0]
                                line = line.split('@', 1)[-1]
                                status = estatus.register_begin
                            elif "}" in line:
                                status = estatus.block_end
                                line = line.split('}', 1)[-1]
                                real_block = 1
                            else:
                                line = ''
                        elif status == estatus.block_end:
                            status = estatus.idle
                            l2xml(o_file_name, new_handle, block_name, subblock_reg_list)
                            new_handle = False
                            field_property_list = []
                            subblock_reg_list = []
                        elif status == estatus.register_begin:
                            if "{" in line:
                                status = estatus.register_doing
                                line = line.split('{', 1)[-1]
                            else:
                                line = ''
                        elif status == estatus.register_doing:
                            if "field" in line:
                                field_name = line.split('field', 1)[-1].replace(' ', '').split('@', 1)[0]
                                field_offset = \
                                line.split('@', 1)[-1].replace(' ', '').replace('\'h', '0x').split('{', 1)[0]
                                line = line.split('@', 1)[-1]
                                status = estatus.field_begin
                            elif '}' in line:
                                status = estatus.register_end
                                line = line.split('}', 1)[-1]
                            else:
                                line = ''
                        elif status == estatus.register_end:
                            subblock_reg_list.append(
                                (reg_name, reg_offset, 'RW', 1, int(block_bytes) * 8, field_property_list))
                            status = estatus.block_doing
                            field_property_list = []
                        elif status == estatus.field_begin:
                            if "{" in line:
                                status = estatus.field_doing
                                line = line.split('{', 1)[-1]
                            else:
                                line = ''
                        elif status == estatus.field_doing:
                            if "bits" in line:
                                field_width = line.split('bits', 1)[-1].replace(' ', '').split(';', 1)[0]
                                line = line.split(';', 1)[-1]
                            elif "access" in line:
                                field_access = line.split('access', 1)[-1].replace(' ', '').split(';', 1)[0].upper()
                                line = line.split(';', 1)[-1]
                            elif "reset" in line:
                                field_init_value = \
                                line.split('reset', 1)[-1].replace(' ', '').replace('\'h', '0x').split(';', 1)[0]
                                line = line.split(';', 1)[-1]
                            elif "doc" in line:
                                status = estatus.field_doc_begin
                                line = line.split('doc', 1)[-1]
                            elif "}" in line:
                                status = estatus.field_end
                                line = line.split('}', 1)[-1]
                            else:
                                line = ''
                        elif status == estatus.field_end:
                            if field_access == 'RW':
                                field_access = 'RWHW'
                            field_property_list.append((field_name, field_offset, field_width, field_access,
                                                        field_init_value, field_description, ''))
                            status = estatus.register_doing
                        elif status == estatus.field_doc_begin:
                            if "{" in line:
                                status = estatus.field_doc_doing
                                line = line.split('{', 1)[-1]
                                field_description = ''
                            else:
                                line = ''
                        elif status == estatus.field_doc_doing:
                            if "{" in line:
                                status = estatus.field_doc_doing_doing
                                field_description += line.split("{",1)[0]
                                line = line.split("{",1)[-1]
                            elif "}" in line and "\}" not in line:
                                status = estatus.field_doc_end
                                field_description += line.split("}",1)[0]
                                line = ''
                            elif "\}" in line:
                                field_description += line.split("\}", 1)[0]
                                field_description += "\}"
                                line = line.split("\}", 1)[-1]
                            else:
                                field_description += line
                                line = ''
                        elif status == estatus.field_doc_doing_doing:
                            if "}" in line:
                                status = estatus.field_doc_doing
                                field_description += line.split("}", 1)[0]
                                line = line.split("}", 1)[-1]
                            else:
                                field_description += line
                                line = ''
                        elif status == estatus.field_doc_end:
                            status = estatus.field_doing
                            field_description = field_description.replace('&','&amp;')
                            field_description = field_description.replace('<','&lt;')
                            field_description = field_description.replace('>','&gt;')
                            field_description = field_description.replace('\'','&apos;')
                            field_description = field_description.replace('\"','&quot;')
                        else:
                            line = ''
                    else:
                        break
            else:
                break
    if real_block == 1:
        l2xml(o_file_name, new_handle, block_name, subblock_reg_list)
    endxmlroot(o_file_name)

if __name__ == "__main__":
    o_ralf_names = []
    i_ralf_names = []
    if '-ipath' in sys.argv and '-opath' in sys.argv:
        i = sys.argv.index('-ipath')
        o = sys.argv.index('-opath')
        default_i_file_path = sys.argv[i + 1]
        default_o_file_path = sys.argv[o + 1]
        print(default_i_file_path)
        print(default_o_file_path)
        i_ralf_names = glob.glob(os.path.join(default_i_file_path, '/*.ralf'))
        print(i_ralf_names)
        for ralf_name in i_ralf_names:
            file_name, suffix = os.path.splitext(ralf_name)
            o_ralf_names.append(default_o_file_path + '/' + file_name + '.xml')

    elif '-ifile' in sys.argv and '-ofile' in sys.argv:
        i = sys.argv.index('-ifile')
        o = sys.argv.index('-ofile')
        i_ralf_names.append(sys.argv[i + 1])
        o_ralf_names.append(sys.argv[o + 1])

    elif '-ifile' in sys.argv and '-opath' in sys.argv:
        i = sys.argv.index('-ifile')
        o = sys.argv.index('-opath')
        i_ralf_names.append(sys.argv[i + 1])
        default_o_file_path = sys.argv[o + 1]
        for ralf_name in i_ralf_names:
            file_name, suffix = os.path.splitext(ralf_name)
            o_ralf_names.append(default_o_file_path + '/' + file_name + '.xml')

    elif '-opath' in sys.argv:
        o = sys.argv.index('-opath')
        default_o_file_path = sys.argv[o + 1]
        i_ralf_names = glob.glob('./*.ralf')
        i_ralf_names += glob.glob('./xml/*.ralf')
        i_ralf_names += glob.glob('./ralf/*.ralf')
        for ralf_name in i_ralf_names:
            file_name, suffix = os.path.splitext(ralf_name)
            o_ralf_names.append(default_o_file_path + '/' + file_name + '.xml')

    elif '-ipath' in sys.argv:
        i = sys.argv.index('-ipath')
        default_i_file_path = sys.argv[i+1]
        i_ralf_names = glob.glob(os.path.join(default_i_file_path, '/*.ralf'))
        for ralf_name in i_ralf_names:
            file_name, suffix = os.path.splitext(ralf_name)
            o_ralf_names.append('./' + file_name + '.xml')

    elif '-ifile' in sys.argv:
        i = sys.argv.index('-ifile')
        i_ralf_names.append(sys.argv[i + 1])
        for ralf_name in list(i_ralf_names):
            file_name, suffix = os.path.splitext(ralf_name)
            o_ralf_names.append('./' + file_name + '.xml')
    else:
        i_ralf_names = glob.glob('./*.ralf')
        i_ralf_names += glob.glob('./xml/*.ralf')
        i_ralf_names += glob.glob('./ralf/*.ralf')
        for ralf_name in i_ralf_names:
            file_name, suffix = os.path.splitext(ralf_name)
            o_ralf_names.append('./' + file_name + '.xml')
    for index, _ in enumerate(i_ralf_names):
        read_ralf(i_ralf_names[index], o_ralf_names[index])
