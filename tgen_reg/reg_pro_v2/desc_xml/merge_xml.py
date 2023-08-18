#!/bin/python3
# author:xpb
# time:2021/1/31-0:12
import os
import glob
from xml.dom import minidom
import sys
import xml.dom.minidom
from xml.dom import Node

# from xml.dom.minidom import parse

def gen_file(f_path, f_name, sys_xml_tree):
    if os.path.exists(f_path) is False:
        os.makedirs(f_path)
    file_name = os.path.abspath(os.path.join(f_path, f_name))
    # sys_xml_tree.write(file_name, encoding='utf-8', xml_declaration=True)
    with open(file_name, "w", encoding="utf-8") as f:
        # sys_xml_tree.writexml(f, indent="")
        sys_xml_tree.writexml(f, '', '\t', '')

def gen_tree():
    global SYS_ROOT
    TMP_ROOTS = []
    trunk_list = []
    id_set = set()
    len_id_min = 1000

    des_xmls = glob.glob('./xml/*reg*.xml')
    des_xmls += glob.glob('./*reg*.xml')
    print(des_xmls)
    for des_xml in des_xmls:
        TMP_ROOTS.append(minidom.parse(des_xml).documentElement)

    for TMP_ROOT in TMP_ROOTS:
        #item_list = TMP_ROOT.getElementsByTagName('all_register')
        #item_list = TMP_ROOT
        #for tmp_item in item_list:
        branch_set = set()
        un = TMP_ROOT.getAttribute('id')
        id_set.add(un)
        un_list = un.split('.')
        if len_id_min > len(un_list):
            len_id_min = len(un_list)
        for un_index,un_value in enumerate(un_list):
            if not un_index < len(trunk_list):
                trunk_list.append(branch_set)
            tmp_branch_set = set(trunk_list[un_index])
            if un_value not in tmp_branch_set:
                tmp_branch_set.add(un_value)
            trunk_list[un_index] = tmp_branch_set
    print(id_set)
    print(trunk_list)

    if '-sys' in sys.argv:
        i = sys.argv.index('-sys')
        file_name = sys.argv[i + 1]
        root_des_xml = file_name.split('/')[-1]
        SYS_ROOT = minidom.parse(root_des_xml).documentElement
    else:
        for TMP_ROOT in TMP_ROOTS:
            un = TMP_ROOT.getAttribute('id')
            un_list = un.split('.')
            if len_id_min == len(un_list):
                SYS_ROOT = TMP_ROOT
                break

    ########### Find the relationship between mother and child by level ########
    for value in range(2,len(trunk_list)+1):
        MOTHER_ROOTS = []
        CHILD_ROOTS = []

        for TMP_ROOT in TMP_ROOTS:
            un = TMP_ROOT.getAttribute('id')
            un_list = un.split('.')
            if len(un_list) == value-1:
                MOTHER_ROOTS.append(TMP_ROOT)
            if len(un_list) == value:
                CHILD_ROOTS.append(TMP_ROOT)

        ########### Connect ########
        for CHILD_ROOT in CHILD_ROOTS:
            USED_ROOT = ''
            un = CHILD_ROOT.getAttribute('id')
            mother_id = ((un[::-1]).split('.',1)[-1])[::-1]
            for MOTHER_ROOT in MOTHER_ROOTS:
                un = MOTHER_ROOT.getAttribute('id')
                if un == mother_id:
                    USED_ROOT = MOTHER_ROOT
                    USED_ROOT.appendChild(CHILD_ROOT)
                    break

    f_path = './'
    if '-o' in sys.argv:
        i = sys.argv.index('-o')
        f_name = sys.argv[i + 1]
    else:
        f_name = 'merge.xml'
    gen_file(f_path, f_name, SYS_ROOT)




def merge_xml():
    global SYS_ROOT
    des_xmls = glob.glob('./xml/*reg*.xml')
    des_xmls += glob.glob('./*reg*.xml')
    # root_des_xml = "xianjing_sys_reg_description.xml"
    if '-sys' in sys.argv:
        i = sys.argv.index('-sys')
        file_name = sys.argv[i + 1]
        root_des_xml = file_name.split('/')[-1]
    else:
        root_des_xml = (glob.glob('./xml/*sys_reg*.xml')[0]).split('/')[-1]
        if len(root_des_xml) == 0:
            root_des_xml = (glob.glob('./*sys_reg*.xml')[0]).split('/')[-1]

    other_roots = []
    block_map_names = set();
    print(des_xmls)
    for des_xml in des_xmls:
        print(des_xml)
        if root_des_xml in des_xml:
            SYS_ROOT = minidom.parse(des_xml).documentElement
            block_map_list = SYS_ROOT.getElementsByTagName('block_map')
            for block_map in block_map_list:
                block_map_names.add(block_map.getElementsByTagName('block_name')[0].childNodes[0].data.replace(' ', ''))
        else:
            b_root = minidom.parse(des_xml).documentElement
            # other_roots.append(minidom.parse(des_xml).documentElement)
            b_roots = b_root.getElementsByTagName('subblock')
            for other_root in b_roots:
                other_roots.append(other_root)

    for other_root in other_roots:
        subblock_name = other_root.getElementsByTagName('subblock_name')[0].childNodes[0].data.replace(' ', '')
        if subblock_name in block_map_names:
            print("abc")
            print(subblock_name)
            SYS_ROOT.appendChild(other_root)
            block_map_names.remove(subblock_name)
        else:
            print("Warning::::Subblock not belong sys_reg,please check the xml subblock_name=【{}】".format(
                subblock_name))

    f_path = './'
    if '-o' in sys.argv:
        i = sys.argv.index('-o')
        f_name = sys.argv[i + 1]
    else:
        f_name = 'merge.xml'
    gen_file(f_path, f_name, SYS_ROOT)

if __name__ == "__main__":
    if '-id' in sys.argv:
        gen_tree()
    else:
        merge_xml()
