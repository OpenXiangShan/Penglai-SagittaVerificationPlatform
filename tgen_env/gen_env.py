#!/sdata/tools/opensrc/spack/opt/spack/linux-centos7-sandybridge/gcc-11.2.0/python-3.8.12-yjwcae5nkvtg3ph5cu356f6dnegcm2k3/bin/python
# coding=utf-8

import os, sys, time, re, random
import ast, shutil
try:
    # Python3
    from configparser import ConfigParser
    from tkinter import *
    from tkinter import messagebox
    from tkinter import ttk
except ImportError:
    # Python2
    from ConfigParser import ConfigParser
    from Tkinter import *
    from Tkinter import messagebox
    from Tkinter import ttk

def genFile(path,name,context):
    fileName = os.path.abspath(os.path.join(path,name))
    File = open(fileName,"w",encoding='utf-8')
    File.write(context)
    File.close()

def chmodXfile(path,name):
    fileName = os.path.abspath(os.path.join(path,name))
    os.system("chmod +x {_file}".format(_file=fileName))

def genTitle(AuthorName,ModuleName,FileType,Discribution):
    global CurrTime
    Title = '''//=========================================================
//File name    : {_moduleName}.{_fileType}
//Author       : {_authorName}
//Module name  : {_moduleName}
//Discribution : {_moduleName} : {_Discribution}
//Date         : {_CurrTime}
//=========================================================
`ifndef {_UmoduleName}__SV
`define {_UmoduleName}__SV
'''.format(_moduleName=ModuleName,_fileType=FileType,_authorName=AuthorName,_CurrTime=CurrTime,_UmoduleName=ModuleName.upper(),_Discribution=Discribution)
    return Title

##========================================================================do copy=============================================================================================
def copyAssertionLib(path):
    global CurrPath
    assertionLibPath = os.path.abspath(os.path.join(path,'tcnt_assertion'))
    if os.path.exists(assertionLibPath) is True:
        print("tcnt_assertion had exists!!!")
    else:
        comAssertionLibPath = os.path.abspath(os.path.join(CurrPath,'../../common_agent','tcnt_assertion'))
        if os.path.exists(comAssertionLibPath) is True:
            shutil.copytree(comAssertionLibPath,assertionLibPath)
        else:
            print(str(sys._getframe().f_lineno) + "@" + "ERROR::::{} not exists, env gen failed!!!".format(comAssertionLibPath))
            sys.exit()

def copyTCNTBase(path):
    global CurrPath
    hcBasePath = os.path.abspath(os.path.join(path,'tcnt_base'))
    if os.path.exists(hcBasePath) is True:
        print("tcnt_base had exists!!!")
    else:
        comHcbasePath = os.path.abspath(os.path.join(CurrPath,'common_src','tcnt_base'))
        if os.path.exists(comHcbasePath) is True:
            #os.makedirs(hcBasePath)
            #print("copy from {_comHcbasePath}".format(_comHcbasePath=comHcbasePath))
            shutil.copytree(comHcbasePath,hcBasePath)
        else:
            print(str(sys._getframe().f_lineno) + "@" + "ERROR::::{} not exists, env gen failed!!!".format(comHcbasePath))
            sys.exit()

def doFileCopy(srcPath,srcFile,dstPath,dstFile):
    tmpDstFile = os.path.abspath(os.path.join(dstPath,dstFile))
    fileIsExists = False
    if os.path.exists(tmpDstFile) is True:
        print("{} had exists!!!".format(dstFile))
        fileIsExists = True
    else:
        tmpSrcFile = os.path.abspath(os.path.join(srcPath,srcFile))
        if os.path.exists(tmpSrcFile) is True:
            # print("copy {_dstFile} from {_srcFile}".format(_dstFile=dstFile,_srcFile=srcFile))
            shutil.copyfile(tmpSrcFile,tmpDstFile)
        else:
            print(str(sys._getframe().f_lineno) + "@" + "ERROR::::{} not exists, env gen failed!!!".format(tmpSrcFile))
            sys.exit()
    return fileIsExists

def copyPrjMakefile(path):
    global CurrPath
    srcPath = os.path.abspath(os.path.join(CurrPath,'common_src','makefile_dir'))
    dstPath = path
    makefileList = ['project_cfg.mk','project_cfg_vcs.mk','project_cfg_xrun.mk']
    for makefile in makefileList:
        srcFile = makefile
        dstFile = makefile
        fileIsExists = doFileCopy(srcPath,srcFile,dstPath,dstFile)

def doScriptListCopy(scriptList,srcPath,dstPath):
    for scrpt in scriptList:
        srcFile = scrpt
        dstFile = scrpt
        fileIsExists = doFileCopy(srcPath,srcFile,dstPath,dstFile)
        if fileIsExists is False:
            chmodXfile(dstPath,dstFile)

def copyPrjScript(path):
    global CurrPath
    srcPath = os.path.abspath(os.path.join(CurrPath,'common_src','common_script'))
    dstPath = path
    scriptList = ["DoFormal.pl","DoRegress.py","DoRegress.sh"]
    doScriptListCopy(scriptList,srcPath,dstPath)

def copySourceScrpit(PathDict):
    global CurrPath
    #script
    srcPath = os.path.abspath(os.path.join(CurrPath,'common_src','common_script'))
    dstPath = PathDict['scr_verif']
    scriptList = ["coverage_revert.py","timing_violation_filter.py"]
    doScriptListCopy(scriptList,srcPath,dstPath)

    dstPath = PathDict['scr_common']
    scriptList = ["create_tag"]
    doScriptListCopy(scriptList,srcPath,dstPath)
    #source
    srcPath = os.path.abspath(os.path.join(CurrPath,'common_src','source_script'))
    dstPath = PathDict['scr_verif']
    scriptList = ["verif.cshrc"]
    doScriptListCopy(scriptList,srcPath,dstPath)

    dstPath = PathDict['scr']
    scriptList = ["project.cshrc","proj_tool.cshrc"]
    doScriptListCopy(scriptList,srcPath,dstPath)


def doScrpitCopy(PathDict):
    copyTCNTBase(PathDict['ver_common'])
    copyAssertionLib(PathDict['ver_common'])
    copyPrjMakefile(PathDict['scr_verif'])
    copyPrjScript(PathDict['scr_verif'])
    copySourceScrpit(PathDict)

##========================================================================env common=============================================================================================
def genEnvCommon_fileList(GeneralDict, path):
    ModuleName = '{_envName}_common'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'file list'
    FileType = 'f'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''
+incdir+./src
{_envName}_common_pkg.sv

// ./src/{_envName}_dec.sv
// ./src/{_envName}_common_xaction.sv
// ./src/{_envName}_fcov.sv

'''.format(_envName=GeneralDict['env_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genEnvCommon_package(GeneralDict, AgentList, path):
    ModuleName = '{_envName}_common_pkg'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'package'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    importAgent = ""
    for agent in AgentList:
        if agent['instance_by']=='self' or 'filelist_path' in agent.keys():
            agentName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
            importAgent += "    import {_agentName}_agent_dec::*;\n".format(_agentName=agentName)
            importAgent += "    import {_agentName}_agent_pkg::*;\n".format(_agentName=agentName)
    fileContext = '''{_Title}
`ifndef TCNT_HAD_INCLUDE_UVM_MACROS
`define TCNT_HAD_INCLUDE_UVM_MACROS
    `include "uvm_macros.svh"
`endif

`include "{_envName}_dec.sv"
package {_envName}_common_pkg;

    import uvm_pkg::*;
    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tcnt_common_method::*;
    import tcnt_base_pkg::*;

    import {_envName}_dec::*;

{_importAgent}
    `include "{_envName}_common_xaction.sv"
    `include "{_envName}_fcov.sv"

endpackage

import {_envName}_common_pkg::*;

`endif

'''.format(_Title=Title,_envName=GeneralDict['env_name'],_importAgent=importAgent)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genEnvCommon_dec(GeneralDict,AgentList,path):
    ModuleName = '{_envName}_dec'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'common parameter'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    Parameter = ""
    if "env_parameter" in GeneralDict.keys():
        for params in GeneralDict['env_parameter']:
            Parameter += "    parameter {} = {};\n".format(params,GeneralDict['env_parameter'][params])
    fileContext = '''{_Title}
package {_envName}_dec;
{_Parameter}
endpackage

import {_envName}_dec::*;

`endif

'''.format(_Title=Title,_envName=GeneralDict['env_name'],_Parameter=Parameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def getEnvParameter(GeneralDict):
    if "env_parameter" in GeneralDict.keys():
        classParameter = "#("
        parameterList = "#("
        for params in GeneralDict['env_parameter']:
            classParameter += "parameter {_params} = {_envName}_dec::{_params},".format(_params=params,_envName=GeneralDict['env_name'])
            parameterList += ".{_params}({_params}),".format(_params=params)
        classParameter = classParameter[:-1]
        classParameter += ") "
        parameterList = parameterList[:-1]
        parameterList += ")"
    else:
        classParameter = ""
        parameterList = ""
    return classParameter,parameterList

def genEnvCommon_common_xaction(GeneralDict, AgentList,path):
    ModuleName = '{_envName}_common_xaction'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'common transaction'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    memberDeclare,memberFactory,packFunctionName,packFunction,memberPsDispaly,compareFunction = '','','','','',''
    instanceByAgentList = []
    idx = 0
    for agent in AgentList:
        if agent['instance_by']=='self' or 'filelist_path' in agent.keys():
            agentName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
            if agentName in instanceByAgentList:
                continue
            instanceByAgentList.append(agentName)
            packFunctionName += ' '*4+'extern function void pack_{_agentName}(uvm_object tr);\n'.format(_agentName=agentName)
            packFunction += '''
function void {_moduleName}::pack_{_agentName}(uvm_object tr);
    {_agentName}_agent_xaction tr_;
    if(!$cast(tr_, tr)) begin
        `uvm_fatal(get_type_name(),$sformatf("tr is not a {_agentName}_agent_xaction or its extend"));
    end
    this.{_agentName}_tr = tr_;
'''.format(_moduleName=ModuleName,_agentName=agentName)
            # Declare Info
            memberDeclare += ' '*4+'{_agentName}_agent_xaction {_agentName}_tr;\n'.format(_agentName=agentName)
            # Factory Info
            memberFactory += ' '*8+'`uvm_field_object({_agentName}_tr, UVM_ALL_ON);\n'.format(_agentName=agentName)
            # Psdisplay Info
            memberPsDispaly += ' '*4+'if(channel_id == {})begin\n'.format(idx)
            memberPsDispaly += ' '*8+'pkt_str = $sformatf("%s%s",pkt_str,this.{_agentName}_tr.psdisplay(prefix));\n'.format(_agentName=agentName)
            memberPsDispaly += ' '*4+'end\n'.format(_agentName=agentName)
            # Compare Info
            compareFunction += ' '*8+'if(channel_id == {})begin\n'.format(idx)
            compareFunction += ' '*12+'super_result = this.{_agentName}_tr.compare(rhs_.{_agentName}_tr);\n'.format(_agentName=agentName)
            compareFunction += ' '*8+'end\n'.format(idx)
            packFunction += 'endfunction:pack_{_agentName}\n'.format(_agentName=agentName)
            idx += 1
    classParameter,parameterList = getEnvParameter(GeneralDict)
    if "env_parameter" in GeneralDict.keys():
        registerParameter = "`uvm_object_param_utils_begin({_moduleName}{_parameterList})".format(_moduleName=ModuleName,_parameterList=parameterList)
    else:
        registerParameter = "`uvm_object_utils_begin({_moduleName})".format(_moduleName=ModuleName)
    fileContext = '''{_Title}
class {_moduleName} {_classParameter} extends tcnt_data_base;
{_memberDeclare}
    extern function new(string name="{_moduleName}");
    extern function void pack();
    extern function void unpack();
    extern function void pre_randomize();
    extern function void post_randomize();
{_packFunctionName}
    extern function string psdisplay(string prefix = "");
    extern function bit compare(uvm_object rhs, uvm_comparer comparer=null);

    {_registerParameter}
{_memberFactory}
    `uvm_object_utils_end

endclass:{_moduleName}

function {_moduleName}::new(string name = "{_moduleName}");
    super.new();
endfunction:new

function void {_moduleName}::pack();
    super.pack();
endfunction:pack
function void {_moduleName}::unpack();
    super.unpack();
endfunction:unpack
function void {_moduleName}::pre_randomize();
    super.pre_randomize();
endfunction:pre_randomize
function void {_moduleName}::post_randomize();
    super.post_randomize();
    //this.pack();
endfunction:post_randomize
{_packFunction}
function string {_moduleName}::psdisplay(string prefix = "");
    string pkt_str;
    pkt_str = $sformatf("%s for packet[%0d] >>>>",prefix,this.pkt_index);
    pkt_str = $sformatf("%schannel_id=%0d ",pkt_str,this.channel_id);
    pkt_str = $sformatf("%sstart=%0f finish=%0f >>>>\\n",pkt_str,this.start,this.finish);
    //foreach(this.pload_q[i]) begin
    //    pkt_str = $sformatf("%spload_q[%0d]=0x%2h  ",pkt_str,i,this.pload_q[i]);
    //end
{_memberPsDispaly}
    return pkt_str;
endfunction:psdisplay

function bit {_moduleName}::compare(uvm_object rhs, uvm_comparer comparer=null);
    bit super_result;
    {_moduleName} {_parameterList} rhs_;
    if(!$cast(rhs_, rhs)) begin
        `uvm_fatal(get_type_name(),$sformatf("rhs is not a {_moduleName} or its extend"))
    end
    super_result = super.compare(rhs_,comparer);
    if(super_result==0) begin
        super_result = 1;
        //foreach(this.pload_q[i]) begin
        //    if(this.pload_q[i]!=rhs_.pload_q[i]) begin
        //        super_result = 0;
        //        `uvm_info(get_type_name(),$sformatf("compare fail for this.pload[%0d]=0x%2h while the rhs_.pload[%0d]=0x%2h",i,this.pload_q[i],i,rhs_.pload_q[i]),UVM_NONE)
        //    end
        //end
{_compareFunction}
    end
    return super_result;
endfunction:compare

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_classParameter=classParameter,_registerParameter=registerParameter,_memberDeclare=memberDeclare,_packFunctionName=packFunctionName,\
    _memberFactory=memberFactory,_packFunction=packFunction,_memberPsDispaly=memberPsDispaly,_parameterList=parameterList,_compareFunction=compareFunction,_envName=GeneralDict['env_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genEnvCommon_fcov(GeneralDict,path):
    ModuleName = '{_envName}_fcov'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'function coverage'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''{_Title}
class {_envName}_fcov;
    //bit [31:0] abc;
    //bit [1:0] ddd;
    //covergroup aaa_cg;
    //    abc_cp : coverpoint abc;
    //    ddd_cp : ddd data_type {{bins value[]={{1,2}};}}
    //    abc_cp_X_ddd_cp : cross abc_cp,ddd_cp{{
    //        ignore_bins ddd_1=binsof(ddd_cp)intersect{{1}};
    //    }}
    //endgroup
    extern function new();
    //extern function void aaa_sp(bit [31:0] abc,bit [1:0] ddd);
endclass
function {_envName}_fcov::new();
    //aaa_sp = new();
endfunction
//function void {_envName}_fcov::aaa_sp(bit [31:0] abc,bit [1:0] ddd);
//    this.abc = abc;
//    this.ddd = ddd;
//    aaa_cg.sample();
//endfunction

`endif

'''.format(_Title=Title,_envName=GeneralDict['env_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genEnvCommon(GeneralDict, AgentList, PathDict):
    genEnvCommon_fileList(GeneralDict,PathDict['env_common'])
    genEnvCommon_package(GeneralDict,AgentList,PathDict['env_common'])
    genEnvCommon_dec(GeneralDict,AgentList,PathDict['env_common_src'])
    genEnvCommon_common_xaction(GeneralDict,AgentList,PathDict['env_common_src'])
    genEnvCommon_fcov(GeneralDict,PathDict['env_common_src'])

##========================================================================agent=============================================================================================
def genAgent_fileList(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'file list'
    FileType = 'f'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''
+incdir+./src
{_agentName}_agent_pkg.sv

// ./src/{_agentName}_agent_dec.sv
// ./src/{_agentName}_agent_interface.sv
// ./src/{_agentName}_agent_cfg.sv
// ./src/{_agentName}_agent_xaction.sv
// ./src/{_agentName}_agent_default_sequence.sv
// ./src/{_agentName}_agent_driver.sv
// ./src/{_agentName}_agent_monitor.sv
// ./src/{_agentName}_agent_sequencer.sv
// ./src/{_agentName}_agent.sv

'''.format(_agentName=agent['agent_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_package(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_pkg'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'package'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''{_Title}
`ifndef TCNT_HAD_INCLUDE_UVM_MACROS
`define TCNT_HAD_INCLUDE_UVM_MACROS
    `include "uvm_macros.svh"
`endif

`include "{_agentName}_agent_dec.sv"
`include "{_agentName}_agent_interface.sv"
package {_agentName}_agent_pkg;

    import uvm_pkg::*;
    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tcnt_common_method::*;
    import tcnt_base_pkg::*;

    import {_agentName}_agent_dec::*;

    `include "{_agentName}_agent_cfg.sv"
    `include "{_agentName}_agent_xaction.sv"
    `include "{_agentName}_agent_default_sequence.sv"
    `include "{_agentName}_agent_driver.sv"
    `include "{_agentName}_agent_monitor.sv"
    `include "{_agentName}_agent_sequencer.sv"
    `include "{_agentName}_agent.sv"

endpackage

import {_agentName}_agent_pkg::*;

`endif

'''.format(_Title=Title,_agentName=agent['agent_name'],_envName=GeneralDict['env_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_dec(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_dec'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'parameter'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    Parameter = ""
    if "parameter" in agent.keys():
        for params in agent['parameter']:
            Parameter += "    parameter {} = {};\n".format(params,agent['parameter'][params])
    fileContext = '''{_Title}
package {_moduleName};
{_Parameter}
endpackage:{_moduleName}

import {_moduleName}::*;

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_Parameter=Parameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def getAgentParameter(agent):
    if "parameter" in agent.keys():
        agentClassParameter = "#("
        agentParameterList = "#("
        for params in agent['parameter']:
            agentClassParameter += "parameter {_params} = {_agentName}_agent_dec::{_params},".format(_params=params,_agentName=agent['agent_name'])
            agentParameterList += ".{_params}({_params}),".format(_params=params)
        agentClassParameter = agentClassParameter[:-1]
        agentClassParameter += ") "
        agentParameterList = agentParameterList[:-1]
        agentParameterList += ")"
    else:
        agentClassParameter = ""
        agentParameterList = ""
    return agentClassParameter,agentParameterList

def getAgentDecParameter(agent,agentList):
    tmpAgent = agent
    if agent["instance_by"]!='self':
        agentName = agent["instance_by"]
        for tmp in agentList:
            if tmp["agent_name"]==agent["instance_by"]:
                tmpAgent = tmp
                break
    else:
        agentName = agent["agent_name"]
    if "parameter" in tmpAgent.keys():
        agentDecParameterList = "#("
        for params in tmpAgent['parameter']:
            agentDecParameterList += ".{_params}({_agentName}_agent_dec::{_params}),".format(_params=params,_agentName=agentName)
        agentDecParameterList = agentDecParameterList[:-1]
        agentDecParameterList += ")"
    else:
        agentDecParameterList = ""
    return agentDecParameterList

def genAgent_interface(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_interface'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'signal interface'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    agentClassParameter,agentParameterList = getAgentParameter(agent)
    signalDeclare, drvClocking, monClocking = '','',''
    for signal in agent['agent_interface_list']:
        signalDeclare += ' '*4+'{_signalDeclare}'.format(_signalDeclare=re.compile(r'.* bit ').sub('logic ',signal)).ljust(35)+';\n'
        signalName = re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',signal)).replace(' ','')
        if re.search(re.compile(r'input'),signal):
            drvClocking += ' '*8+'output {_signalName};\n'.format(_signalName=signalName)
        elif re.search(re.compile(r'output'),signal):
            drvClocking += ' '*8+'input  {_signalName};\n'.format(_signalName=signalName)
        else:#inout
            drvClocking += ' '*8+'inout  {_signalName};\n'.format(_signalName=signalName)
        monClocking += ' '*8+'input  {_signalName};\n'.format(_signalName=signalName)
    fileContext = '''{_Title}
`ifndef DEF_SETUP_TIME
    `define DEF_SETUP_TIME 1
`endif
`ifndef DEF_HOLD_TIME
    `define DEF_HOLD_TIME 1
`endif

interface {_moduleName} {_agentClassParameter} (input bit clk,input bit rst_n);

{_signalDeclare}
    clocking drv_cb @(posedge clk);
        `ifdef INTERFACE_ADD_DELAY
            default input #`DEF_SETUP_TIME output #`DEF_HOLD_TIME;
        `endif
{_drvClocking}
    endclocking:drv_cb

    clocking mon_cb @(posedge clk);
        `ifdef INTERFACE_ADD_DELAY
            default input #`DEF_SETUP_TIME output #`DEF_HOLD_TIME;
        `endif
{_monClocking}
    endclocking:mon_cb

    modport drv_mp (clocking drv_cb);
    modport mon_mp (clocking mon_cb);

endinterface:{_moduleName}

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_agentClassParameter=agentClassParameter,_signalDeclare=signalDeclare,_drvClocking=drvClocking,_monClocking=monClocking,_agentName=agent['agent_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_xaction(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_xaction'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'agent transaction'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    agentClassParameter,agentParameterList = getAgentParameter(agent)
    if "parameter" in agent.keys():
        agentRegisterParameter = "`uvm_object_param_utils_begin({_moduleName}{_agentParameterList})".format(_moduleName=ModuleName,_agentParameterList=agentParameterList)
    else:
        agentRegisterParameter = "`uvm_object_utils_begin({_moduleName})".format(_moduleName=ModuleName)
    memberDeclare,memberFactory,memberPsDispaly,compareFunction,memberConstraintDeclare,memberConstraint = '','','','','',''
    for signal in agent['agent_interface_list']:
        memberDeclare += ' '*4+'{_signalDeclare}'.format(_signalDeclare=re.compile(r'.* bit ').sub('rand bit ',signal)).ljust(35)+';\n'
        signalName = re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',signal)).replace(' ','')
        memberFactory += ' '*8+'`uvm_field_int({_signal}, UVM_ALL_ON);\n'.format(_signal=signalName)
        memberPsDispaly += ' '*4+'pkt_str = $sformatf("%s{_signal} = 0x%0h ",pkt_str,this.{_signal});\n'.format(_signal=signalName)
        memberConstraintDeclare += ' '*4+'extern constraint default_{_signal}_cons;\n'.format(_signal=signalName)
        memberConstraint += '''
constraint {_moduleName}::default_{_signal}_cons{{

}}
'''.format(_moduleName=ModuleName,_signal=signalName)
        compareFunction +='''
        if(this.{_signal}!=rhs_.{_signal}) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.{_signal}=0x%0h while the rhs_.{_signal}=0x%0h",this.{_signal},rhs_.{_signal}),UVM_NONE)
        end
'''.format(_signal=signalName)
    fileContext = '''{_Title}
class {_moduleName} {_agentClassParameter} extends tcnt_data_base;
{_memberDeclare}
{_memberConstraintDeclare}
    extern function new(string name="{_moduleName}");
    extern function void pack();
    extern function void unpack();
    extern function void pre_randomize();
    extern function void post_randomize();
    extern function string psdisplay(string prefix = "");
    extern function bit compare(uvm_object rhs, uvm_comparer comparer=null);

    {_agentRegisterParameter}
{_memberFactory}
    `uvm_object_utils_end

endclass:{_moduleName}
{_memberConstraint}
function {_moduleName}::new(string name = "{_moduleName}");
    super.new();
endfunction:new

function void {_moduleName}::pack();
    super.pack();
endfunction:pack
function void {_moduleName}::unpack();
    super.unpack();
endfunction:unpack
function void {_moduleName}::pre_randomize();
    super.pre_randomize();
endfunction:pre_randomize
function void {_moduleName}::post_randomize();
    super.post_randomize();
    //this.pack();
endfunction:post_randomize

function string {_moduleName}::psdisplay(string prefix = "");
    string pkt_str;
    pkt_str = $sformatf("%s for packet[%0d] >>>>",prefix,this.pkt_index);
    pkt_str = $sformatf("%schannel_id=%0d ",pkt_str,this.channel_id);
    pkt_str = $sformatf("%sstart=%0f finish=%0f >>>>\\n",pkt_str,this.start,this.finish);
    //foreach(this.pload_q[i]) begin
    //    pkt_str = $sformatf("%spload_q[%0d]=0x%2h  ",pkt_str,i,this.pload_q[i]);
    //end
{_memberPsDispaly}
    return pkt_str;
endfunction:psdisplay

function bit {_moduleName}::compare(uvm_object rhs, uvm_comparer comparer=null);
    bit super_result;
    {_moduleName} {_agentParameterList} rhs_;
    if(!$cast(rhs_, rhs)) begin
        `uvm_fatal(get_type_name(),$sformatf("rhs is not a {_moduleName} or its extend"))
    end
    super_result = super.compare(rhs_,comparer);
    if(super_result==0) begin
        super_result = 1;
        //foreach(this.pload_q[i]) begin
        //    if(this.pload_q[i]!=rhs_.pload_q[i]) begin
        //        super_result = 0;
        //        `uvm_info(get_type_name(),$sformatf("compare fail for this.pload[%0d]=0x%2h while the rhs_.pload[%0d]=0x%2h",i,this.pload_q[i],i,rhs_.pload_q[i]),UVM_NONE)
        //    end
        //end
{_compareFunction}
    end
    return super_result;
endfunction:compare

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_memberDeclare=memberDeclare,_memberConstraintDeclare=memberConstraintDeclare,_memberFactory=memberFactory,_memberConstraint=memberConstraint,_memberPsDispaly=memberPsDispaly,\
    _compareFunction=compareFunction,_agentName=agent['agent_name'],_agentClassParameter=agentClassParameter,_agentParameterList=agentParameterList,_agentRegisterParameter=agentRegisterParameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_cfg(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_cfg'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'agent configuration'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''{_Title}
class {_moduleName} extends tcnt_agent_cfg_base;

    `uvm_object_utils_begin({_moduleName})
    `uvm_object_utils_end

    extern function new(string name="{_moduleName}");
    extern function void pre_randomize();
    extern function void post_randomize();

endclass:{_moduleName}

function {_moduleName}::new(string  name = "{_moduleName}\");
    super.new(name);
endfunction:new

function void {_moduleName}::pre_randomize();
    super.pre_randomize();
endfunction:pre_randomize

function void {_moduleName}::post_randomize();
    super.post_randomize();
endfunction:post_randomize

`endif

'''.format(_Title=Title,_moduleName=ModuleName)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_default_sequence(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_default_sequence'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'default sequence'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    agentClassParameter,agentParameterList = getAgentParameter(agent)
    if "parameter" in agent.keys():
        agentRegisterParameter = "`uvm_object_param_utils({_moduleName}{_agentParameterList})".format(_moduleName=ModuleName,_agentParameterList=agentParameterList)
    else:
        agentRegisterParameter = "`uvm_object_utils({_moduleName})".format(_moduleName=ModuleName)
    fileContext = '''{_Title}
class {_moduleName} {_agentClassParameter} extends tcnt_default_sequence_base #({_agentName}_agent_xaction{_agentParameterList});

    {_agentRegisterParameter}

    extern function new(string name="{_moduleName}\");
    extern virtual task pre_body();
    extern virtual task body();
    extern virtual task post_body();

endclass:{_moduleName}

function  {_moduleName}::new(string name= "{_moduleName}");
    super.new(name);
endfunction:new

task {_moduleName}::pre_body();
    if(starting_phase != null)
        starting_phase.raise_objection(this);
endtask:pre_body

task {_moduleName}::body();
    repeat (10) begin
        `uvm_do(req)
    end
endtask:body

task {_moduleName}::post_body();
    if(starting_phase != null)
        starting_phase.drop_objection(this);
endtask:post_body

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_agentName=agent['agent_name'],_agentClassParameter=agentClassParameter,_agentParameterList=agentParameterList,_agentRegisterParameter=agentRegisterParameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_driver(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_driver'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'driver'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    agentClassParameter,agentParameterList = getAgentParameter(agent)
    if "parameter" in agent.keys():
        agentRegisterParameter = "`uvm_component_param_utils({_moduleName}{_agentParameterList})".format(_moduleName=ModuleName,_agentParameterList=agentParameterList)
    else:
        agentRegisterParameter = "`uvm_component_utils({_moduleName})".format(_moduleName=ModuleName)
    drvIdle,drvTr = '',''
    drvIdle0,drvIdle1,drvIdleX,drvIdleR,drvIdleL = '','','','',''
    for signal in agent['agent_interface_list']:
        if re.search(re.compile(r'output'),signal) is None:
            signalName = re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',signal)).replace(' ','')
            drvTr += ' '*4+'vif.drv_mp.drv_cb.{_signal} <= tr.{_signal}; \n'.format(_signal=signalName)
            drvIdle0 += ' '*8+'''vif.drv_mp.drv_cb.{_signal} <= '0;\n'''.format(_signal=signalName)
            drvIdle1 += ' '*8+'''vif.drv_mp.drv_cb.{_signal} <= '1;\n'''.format(_signal=signalName)
            drvIdleX += ' '*8+'''vif.drv_mp.drv_cb.{_signal} <= 'x;\n'''.format(_signal=signalName)
            drvIdleR += ' '*8+'''vif.drv_mp.drv_cb.{_signal} <= $urandom;\n'''.format(_signal=signalName)
            drvIdleL += ' '*8+'''vif.drv_mp.drv_cb.{_signal} <= '0;\n'''.format(_signal=signalName)
    drvIdle += '''
    if(drv_mode==tcnt_dec_base::DRV_0) begin
{_drvIdle0}
    end
    else if(drv_mode==tcnt_dec_base::DRV_1) begin
{_drvIdle1}
    end
    else if(drv_mode==tcnt_dec_base::DRV_X) begin
{_drvIdleX}
    end
    else if(drv_mode==tcnt_dec_base::DRV_RAND) begin
{_drvIdleR}
    end
    else if(drv_mode==tcnt_dec_base::DRV_LST) begin
{_drvIdleL}
    end
'''.format(_drvIdle0=drvIdle0,_drvIdle1=drvIdle1,_drvIdleX=drvIdleX,_drvIdleR=drvIdleR,_drvIdleL=drvIdleL)
    fileContext = '''{_Title}
class {_moduleName} {_agentClassParameter} extends tcnt_driver_base#(virtual {_agentName}_agent_interface{_agentParameterList},{_agentName}_agent_cfg,{_agentName}_agent_xaction{_agentParameterList});

    {_agentRegisterParameter}

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task reset_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    extern task send_pkt({_agentName}_agent_xaction{_agentParameterList} tr);
    extern task drive_idle(tcnt_dec_base::drv_mode_e drv_mode);
endclass:{_moduleName}

function {_moduleName}::new(string name, uvm_component parent);
    super.new(name,parent);
endfunction:new

function void {_moduleName}::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase

task {_moduleName}::reset_phase(uvm_phase phase);

    super.reset_phase(phase);
    phase.raise_objection(this);

    repeat(2) begin
        @this.vif.drv_mp.drv_cb;
        this.drive_idle(this.cfg.drv_mode);
    end
    wait(vif.rst_n == 1'b1);
    repeat(20) begin
        @this.vif.drv_mp.drv_cb;
        this.drive_idle(this.cfg.drv_mode);
    end

    phase.drop_objection(this);
endtask:reset_phase

task {_moduleName}::main_phase(uvm_phase phase);
    super.main_phase(phase);
    //while(1) begin
    if(this.cfg.sqr_sw==tcnt_dec_base::ON && this.cfg.drv_sw==tcnt_dec_base::ON) begin
        while(1) begin
            seq_item_port.try_next_item(req);
            if(req!=null) begin
                repeat(req.pre_pkt_gap) begin
                    @this.vif.drv_mp.drv_cb;
                    this.drive_idle(this.cfg.drv_mode);
                end
                @this.vif.drv_mp.drv_cb;
                this.send_pkt(req);
                repeat(req.post_pkt_gap) begin
                    @this.vif.drv_mp.drv_cb;
                    this.drive_idle(this.cfg.drv_mode);
                end
                seq_item_port.item_done();
            end
            else begin
                @this.vif.drv_mp.drv_cb;
                this.drive_idle(this.cfg.drv_mode);
            end
        end
    end
    else if (this.cfg.drv_sw==tcnt_dec_base::ON) begin
        while(1) begin
            @this.vif.drv_mp.drv_cb;
            `uvm_fatal(get_type_name(), $sformatf("sqr_sw==OFF & drv_sw==ON, please give a driver send task!"))
            //send task
        end
    end
endtask:main_phase

task {_moduleName}::send_pkt({_agentName}_agent_xaction{_agentParameterList} tr);
{_drvTr}
endtask:send_pkt

task {_moduleName}::drive_idle(tcnt_dec_base::drv_mode_e drv_mode);
{_drvIdle}
endtask:drive_idle

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_agentName=agent['agent_name'],_drvTr=drvTr,_drvIdle=drvIdle,\
    _agentClassParameter=agentClassParameter,_agentParameterList=agentParameterList,_agentRegisterParameter=agentRegisterParameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_monitor(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_monitor'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'monitor'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    agentClassParameter,agentParameterList = getAgentParameter(agent)
    if "parameter" in agent.keys():
        agentRegisterParameter = "`uvm_component_param_utils({_moduleName}{_agentParameterList})".format(_moduleName=ModuleName,_agentParameterList=agentParameterList)
    else:
        agentRegisterParameter = "`uvm_component_utils({_moduleName})".format(_moduleName=ModuleName)
    signalDeclare,signalSample,signalCheckXZ,signalToTr = '','','',''
    for signal in agent['agent_interface_list']:
        signalDeclare += ' '*4+'{_signalDeclare}'.format(_signalDeclare=re.compile(r'.* bit ').sub('logic ',signal)).ljust(35)+';\n'
        signalName = re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',signal)).replace(' ','')
        signalSample += ' '*8+'{_signal} = this.vif.mon_mp.mon_cb.{_signal};\n'.format(_signal=signalName)
        signalToTr += ' '*8+'//    mon_tr.{_signal} = {_signal};\n'.format(_signal=signalName)
        signalWidth = re.compile(r':[ ]*0.*').sub('',re.compile(r'.*\[').sub('',signal))
        try:
            if re.match(re.compile('[ ]*\d'),signalWidth):
                signalWidth = int(signalWidth.replace(' ',''))+1
            elif re.match(re.compile('.*[ ]*bit[ ]*.*'),signalWidth):
                signalWidth = 1
            elif re.match(re.compile(r'.*-[ ]*1.*'),signalWidth):
                signalWidth = re.compile(r'-[ ]*1').sub('',signalWidth.replace(' ',''))
            else:
                signalWidth = signalWidth.replace(' ','')+'+1'
        except:
            print(str(sys._getframe().f_lineno) + "@" + "WARN::::get the single width error for monitor XZcheck::::{_agentName}.{_signal}>>>>>>{_signalWidth}".format(_agentName=agent['agent_name'],_signal=signalName,_signalWidth=signalWidth))
        signalCheckXZ += ' '*12 + '`TCNT_CHECK_SIG_XZ({_signal},{_signal},{_signalWidth});\n'.format(_signal=signalName,_signalWidth=signalWidth)
    fileContext = '''{_Title}
class {_moduleName} {_agentClassParameter} extends tcnt_monitor_base#(virtual {_agentName}_agent_interface{_agentParameterList},{_agentName}_agent_cfg,{_agentName}_agent_xaction{_agentParameterList});

    {_agentRegisterParameter}

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task mon_data();
endclass:{_moduleName}

function {_moduleName}::new(string name, uvm_component parent);
    super.new(name,parent);
endfunction:new

function void {_moduleName}::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase

task {_moduleName}::run_phase(uvm_phase phase);
    super.run_phase(phase);
    this.mon_data();
endtask:run_phase

task {_moduleName}::mon_data();

{_signalDeclare}
    {_agentName}_agent_xaction {_agentParameterList} mon_tr;
    while(1) begin
        @this.vif.mon_mp.mon_cb;
{_signalSample}
        if(this.cfg.xz_sw==tcnt_dec_base::ON & this.vif.rst_n==1'b1) begin
{_signalCheckXZ}
        end
        //if(xxxTODOxxx==1'b1) begin
        //    mon_tr = {_agentName}_agent_xaction{_agentParameterList}::type_id::create("mon_tr");
{_signalToTr}
        //    mon_tr.channel_id = this.cfg.channel_id;
        //    mon_tr.unpack();
        //    this.mon_item_port.write(mon_tr);
        //end
    end
endtask:mon_data

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_agentName=agent['agent_name'],_signalDeclare=signalDeclare,_signalSample=signalSample,_signalCheckXZ=signalCheckXZ,_signalToTr=signalToTr,\
    _agentClassParameter=agentClassParameter,_agentParameterList=agentParameterList,_agentRegisterParameter=agentRegisterParameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_sequencer(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent_sequencer'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'sequencer'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    agentClassParameter,agentParameterList = getAgentParameter(agent)
    if "parameter" in agent.keys():
        agentRegisterParameter = "`uvm_component_param_utils({_moduleName}{_agentParameterList})".format(_moduleName=ModuleName,_agentParameterList=agentParameterList)
    else:
        agentRegisterParameter = "`uvm_component_utils({_moduleName})".format(_moduleName=ModuleName)
    fileContext = '''{_Title}
class {_moduleName} {_agentClassParameter} extends tcnt_sequencer_base #({_agentName}_agent_xaction{_agentParameterList});
    {_agentRegisterParameter}
    extern function new(string name, uvm_component parent);
    extern task main_phase(uvm_phase phase);
endclass:{_moduleName}

function {_moduleName}::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction:new

task {_moduleName}::main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);
    if(!(uvm_config_db#(uvm_object_wrapper)::exists(this, "main_phase", "default_sequence", 0))) begin
        tcnt_default_sequence_base#(seq_item_t) seq;
        `uvm_warning(get_type_name(),"had no get the default_sequence, please check!!")
        seq = tcnt_default_sequence_base#(seq_item_t)::type_id::create("seq");
        seq.starting_phase = phase;
        seq.start(this);
    end
    phase.drop_objection(this);
endtask:main_phase

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_agentName=agent['agent_name'],_agentClassParameter=agentClassParameter,_agentParameterList=agentParameterList,_agentRegisterParameter=agentRegisterParameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAgent_agent(GeneralDict, agent, path):
    ModuleName = '{_agentName}_agent'.format(_agentName=agent['agent_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'agent top'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    agentClassParameter,agentParameterList = getAgentParameter(agent)
    if "parameter" in agent.keys():
        agentRegisterParameter = "`uvm_component_param_utils({_moduleName}{_agentParameterList})".format(_moduleName=ModuleName,_agentParameterList=agentParameterList)
    else:
        agentRegisterParameter = "`uvm_component_utils({_moduleName})".format(_moduleName=ModuleName)
    fileContext = '''{_Title}
class {_moduleName} {_agentClassParameter} extends tcnt_agent_base#(
                                        .VIF_BUS(virtual {_agentName}_agent_interface{_agentParameterList}),
                                        .cfg_t({_agentName}_agent_cfg),
                                        .seq_t({_agentName}_agent_xaction{_agentParameterList}),
                                        .sqr_t({_agentName}_agent_sequencer{_agentParameterList}),
                                        .drv_t({_agentName}_agent_driver{_agentParameterList}),
                                        .mon_t({_agentName}_agent_monitor{_agentParameterList}));

    {_agentRegisterParameter}
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass:{_moduleName}

function {_moduleName}::new(string name,uvm_component parent);
    super.new(name,parent);
endfunction:new

function void {_moduleName}::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase

function void {_moduleName}::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_agentName=agent['agent_name'],_agentClassParameter=agentClassParameter,_agentParameterList=agentParameterList,_agentRegisterParameter=agentRegisterParameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAllAgent(GeneralDict, AgentList, PathDict):
    for agent in AgentList:
        if agent['instance_by']=='self':
            genAgent_fileList(GeneralDict,agent,PathDict[agent['agent_name']])
            genAgent_package(GeneralDict,agent,PathDict[agent['agent_name']])
            genAgent_dec(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])
            genAgent_interface(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])
            genAgent_xaction(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])
            genAgent_cfg(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])
            genAgent_default_sequence(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])
            genAgent_driver(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])
            genAgent_monitor(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])
            genAgent_sequencer(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])
            genAgent_agent(GeneralDict,agent,PathDict[agent['agent_name']+'_src'])

##========================================================================environment=============================================================================================
def genEnv_fileList(GeneralDict,path):
    ModuleName = '{_envName}_env'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'file list'
    FileType = 'f'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''
+incdir+./src
{_envName}_env_pkg.sv

// ./src/{_envName}_env_cfg.sv
// ./src/{_envName}_rm.sv
// ./src/{_envName}_env.sv

'''.format(_envName=GeneralDict['env_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genEnv_package(GeneralDict, AgentList, path):
    ModuleName = '{_envName}_env_pkg'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'package'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    importAgent = ""
    for agent in AgentList:
        if agent['instance_by']=='self' or 'filelist_path' in agent.keys():
            agentName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
            importAgent += "    import {_agentName}_agent_dec::*;\n".format(_agentName=agentName)
            importAgent += "    import {_agentName}_agent_pkg::*;\n".format(_agentName=agentName)
    fileContext = '''{_Title}
`ifndef TCNT_HAD_INCLUDE_UVM_MACROS
`define TCNT_HAD_INCLUDE_UVM_MACROS
    `include "uvm_macros.svh"
`endif

package {_envName}_env_pkg;

    import uvm_pkg::*;
    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tcnt_common_method::*;
    import tcnt_base_pkg::*;
{_importAgent}

    import {_envName}_dec::*;
    import {_envName}_common_pkg::*;

    `include "{_envName}_env_cfg.sv"
    `include "{_envName}_rm.sv"
    `include "{_envName}_env.sv"

endpackage

import {_envName}_env_pkg::*;

`endif

'''.format(_Title=Title,_envName=GeneralDict['env_name'],_importAgent=importAgent)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genEnv_rm(GeneralDict,AgentList,path):
    ModuleName = '{_envName}_rm'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'reference model'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    classParameter,parameterList = getEnvParameter(GeneralDict)
    if "env_parameter" in GeneralDict.keys():
        registerParameter = "`uvm_component_param_utils({_moduleName}{_parameterList})".format(_moduleName=ModuleName,_parameterList=parameterList)
    else:
        registerParameter = "`uvm_component_utils({_moduleName})".format(_moduleName=ModuleName)
    portDeclare,portNew,TrDeclare,TrProcess,DoPack='','','','',''
    for agent in AgentList:
        instanceByName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
        agentDecParameterList = getAgentDecParameter(agent,AgentList)
        portDeclare +='''
    uvm_blocking_get_port #({_instanceByName}_agent_xaction{_agentDecParameterList}) {_agentName}_mon_item_port;'''.format(_agentName=agent['agent_name'],_instanceByName=instanceByName,_envName=GeneralDict['env_name'],_agentDecParameterList=agentDecParameterList)
        portNew +='''
    this.{_agentName}_mon_item_port = new($sformatf("{_agentName}_mon_item_port"), this);'''.format(_agentName=agent['agent_name'])
        TrDeclare +='''
    {_instanceByName}_agent_xaction {_agentDecParameterList} {_agentName}_tr_in;
    {_envName}_common_xaction {_parameterList} {_agentName}_tr_out;
'''.format(_agentName=agent['agent_name'],_instanceByName=instanceByName,_envName=GeneralDict['env_name'],_parameterList=parameterList,_agentDecParameterList=agentDecParameterList)
        DoPack = ' '*12+'{_agentName}_tr_out.pack_{_instanceByName}({_agentName}_tr_in);\n'.format(_agentName=agent['agent_name'],_instanceByName=instanceByName)
        if "scb_port_sel" in agent.keys():
            if agent["scb_port_sel"]=="exp":
                scbConnect = '''
            this.rm_item_exp_port.write({_agentName}_tr_out);
            //this.rm_item_act_port.write({_agentName}_tr_out);'''.format(_agentName=agent['agent_name'])
            else:
                scbConnect = '''
            //this.rm_item_exp_port.write({_agentName}_tr_out);
            this.rm_item_act_port.write({_agentName}_tr_out);'''.format(_agentName=agent['agent_name'])
        else:
                scbConnect = '''
            this.rm_item_exp_port.write({_agentName}_tr_out);
            //this.rm_item_act_port.write({_agentName}_tr_out);'''.format(_agentName=agent['agent_name'])
        TrProcess +='''
        while(1)begin
            this.{_agentName}_mon_item_port.get({_agentName}_tr_in);
            `uvm_info(get_type_name(),$sformatf("{_agentName}_mon_item_port get as %s",{_agentName}_tr_in.psdisplay()),UVM_DEBUG)
            //if(!$cast({_agentName}_tr_out, {_agentName}_tr_in)) begin
            //    `uvm_fatal(get_type_name(),$sformatf("{_agentName}_tr_in,is not a {_envName}_common_xaction or its extend\"))
            //end
            {_agentName}_tr_out = {_envName}_common_xaction{_parameterList}::type_id::create("{_agentName}_tr_out");
            {_agentName}_tr_out.channel_id = {_agentName}_tr_in.channel_id;
{_DoPack}
{_scbConnect}
        end
'''.format(_agentName=agent['agent_name'],_envName=GeneralDict['env_name'],_parameterList=parameterList,_DoPack=DoPack,_scbConnect=scbConnect[1:])
    fileContext = '''{_Title}
class {_moduleName} {_classParameter} extends tcnt_rm_base #(.seq_item_t({_envName}_common_xaction{_parameterList}));

    //virtual tc_if vif;
    {_envName}_env_cfg cfg;

    //aa_test_reg_model		reg_model;
{_portDeclare}

    {_registerParameter}

    extern         function      new(string name , uvm_component parent);
    extern         function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    extern virtual task main_process();
endclass

function {_moduleName}::new(string name , uvm_component parent);
    super.new(name, parent);
endfunction

function void {_moduleName}::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //if(!uvm_config_db#(virtual tc_if)::get(this, "", "vif", vif)) begin
    //    `uvm_fatal(get_type_name(),$sformatf("virtual interface must be set for vif(tc_if)!!!"))
    //end
    if(!uvm_config_db#({_envName}_env_cfg)::get(this,"","cfg",this.cfg)) begin
        `uvm_fatal(get_type_name(),$sformatf("build_phase: env cfg is not set!!!"));
    end else begin
        `uvm_info(get_type_name(),$sformatf("build_phase: get_cfg !!!"),UVM_DEBUG);
    end
{_portNew}

endfunction

task {_moduleName}::main_phase(uvm_phase phase);
    super.main_phase(phase);
    this.main_process();
endtask

task {_moduleName}::main_process();
{_TrDeclare}
    fork
{_TrProcess}
    join_none
endtask

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_envName=GeneralDict['env_name'],_portDeclare=portDeclare,_portNew=portNew,_TrDeclare=TrDeclare,_TrProcess=TrProcess,\
    _classParameter=classParameter,_registerParameter=registerParameter,_parameterList=parameterList)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genEnv_cfg(GeneralDict,AgentList,path):
    ModuleName = '{_envName}_env_cfg'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'environment configuration'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    memberDeclare,memberNew,memberPostRand= "","",""
    channelIdx = 0
    for agent in AgentList:
        instanceByName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
        if agent['agent_mode']=='master':
            masterSW = "tcnt_dec_base::ON "
        else:
            masterSW = "tcnt_dec_base::OFF"
        if "channel_id_s" in agent.keys():
            channelIdx = int(agent["channel_id_s"])
        if agent['instance_type']=='string':
            memberDeclare +=' '*4 + 'rand ' + '{_instanceByName}_agent_cfg'.format(_instanceByName=instanceByName).ljust(25) +' u_{_agentName}_agent_cfg[string];\n'.format(_agentName=agent['agent_name'])
            for stringName in agent['instance_list']:
                memberNew += ' '*4 + 'this.u_{_agentName}_agent_cfg[{_stringName}]'.format(_agentName=agent['agent_name'],_stringName=stringName).ljust(30) + \
                    ' = {_instanceByName}_agent_cfg::type_id::create($sformatf("u_{_agentName}_agent_cfg[%s]",{_stringName}));\n'.format(_agentName=agent['agent_name'],_instanceByName=instanceByName,_stringName=stringName)
                memberPostRand +='''
    this.u_{_agentName}_agent_cfg[{_stringName}].sqr_sw = {_masterSW} ;
    this.u_{_agentName}_agent_cfg[{_stringName}].drv_sw = {_masterSW} ;
    this.u_{_agentName}_agent_cfg[{_stringName}].mon_sw = tcnt_dec_base::ON ;
'''.format(_agentName=agent['agent_name'],_masterSW=masterSW,_stringName=stringName)
                memberPostRand += ' '*4 + 'this.u_{_agentName}_agent_cfg[{_stringName}].channel_id = {_channelIdx};\n'.format(_agentName=agent['agent_name'],_stringName=stringName,_channelIdx=channelIdx)
                channelIdx += 1
        elif agent['instance_num']==1:
            memberDeclare +=' '*4 + 'rand ' + '{_instanceByName}_agent_cfg'.format(_instanceByName=instanceByName).ljust(25) +' u_{_agentName}_agent_cfg;\n'.format(_agentName=agent['agent_name'])
            memberNew += ' '*4 + 'this.u_{_agentName}_agent_cfg'.format(_agentName=agent['agent_name']).ljust(30) + ' = {_instanceByName}_agent_cfg::type_id::create("u_{_agentName}_agent_cfg");\n'.format(_agentName=agent['agent_name'],_instanceByName=instanceByName)
            memberPostRand +='''
    this.u_{_agentName}_agent_cfg.sqr_sw = {_masterSW} ;
    this.u_{_agentName}_agent_cfg.drv_sw = {_masterSW} ;
    this.u_{_agentName}_agent_cfg.mon_sw = tcnt_dec_base::ON ;
    this.u_{_agentName}_agent_cfg.channel_id = {_channelIdx};
'''.format(_agentName=agent['agent_name'],_masterSW=masterSW,_channelIdx=channelIdx)
            channelIdx += 1
        else:
            memberDeclare +=' '*4 + 'rand ' + '{_instanceByName}_agent_cfg'.format(_instanceByName=instanceByName).ljust(25) +' u_{_agentName}_agent_cfg[{_instanceNum}];\n'.format(_agentName=agent['agent_name'],_instanceNum=agent['instance_num'])
            memberNew += ' '*4 + 'foreach(this.u_{_agentName}_agent_cfg[i]) begin\n'.format(_agentName=agent['agent_name'])
            memberNew += ' '*8 + 'this.u_{_agentName}_agent_cfg[i]'.format(_agentName=agent['agent_name']).ljust(30) + ' = {_instanceByName}_agent_cfg::type_id::create($sformatf("u_{_agentName}_agent_cfg[%0d]",i));\n'.format(_agentName=agent['agent_name'],_instanceByName=instanceByName)
            memberNew += ' '*4 + 'end\n'
            memberPostRand += ' '*4 + 'foreach(this.u_{_agentName}_agent_cfg[i]) begin'.format(_agentName=agent['agent_name'])
            memberPostRand +='''
        this.u_{_agentName}_agent_cfg[i].sqr_sw = {_masterSW} ;
        this.u_{_agentName}_agent_cfg[i].drv_sw = {_masterSW} ;
        this.u_{_agentName}_agent_cfg[i].mon_sw = tcnt_dec_base::ON ;
'''.format(_agentName=agent['agent_name'],_masterSW=masterSW)
            memberPostRand += ' '*4 + 'end\n'
            for loop_i in range(agent['instance_num']):
                memberPostRand += ' '*4 + 'this.u_{_agentName}_agent_cfg[{_loopI}].channel_id = {_channelIdx};\n'.format(_agentName=agent['agent_name'],_loopI=loop_i,_channelIdx=channelIdx)
                channelIdx += 1

    fileContext = '''{_Title}
class {_moduleName} extends uvm_object;

{_memberDeclare}
    `uvm_object_utils_begin({_moduleName})
    `uvm_object_utils_end

    extern function new(string name="{_moduleName}");
    extern function void pre_randomize();
    extern function void post_randomize();

endclass:{_moduleName}

function {_moduleName}::new(string  name = "{_moduleName}\");
    super.new(name);
{_memberNew}
endfunction:new

function void {_moduleName}::pre_randomize();
    super.pre_randomize();
endfunction:pre_randomize

function void {_moduleName}::post_randomize();
    super.post_randomize();
{_memberPostRand}
endfunction:post_randomize

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_memberDeclare=memberDeclare,_memberNew=memberNew,_memberPostRand=memberPostRand)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genEnv_env(GeneralDict,AgentList,path):
    ModuleName = '{_envName}_env'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = 'environment top'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    classParameter,parameterList = getEnvParameter(GeneralDict)
    if "env_parameter" in GeneralDict.keys():
        registerParameter = "`uvm_component_param_utils({_moduleName}{_parameterList})".format(_moduleName=ModuleName,_parameterList=parameterList)
    else:
        registerParameter = "`uvm_component_utils({_moduleName})".format(_moduleName=ModuleName)
    memberDeclare,memberNew,fifoConnect, = '','',''
    memberDeclare +='    {_envName}_env_cfg cfg;\n'.format(_envName=GeneralDict['env_name'])
    memberNew +='''
    if(!uvm_config_db#({_envName}_env_cfg)::get(this,"","cfg",this.cfg)) begin
        cfg = {_envName}_env_cfg::type_id::create("cfg",this);
        void'(this.cfg.randomize());
        `uvm_info(get_type_name(),$sformatf("build_phase: env cfg is not set, create and randomize by self!!!"),UVM_NONE);
    end else begin
        `uvm_info(get_type_name(),$sformatf("build_phase: get_cfg !!!"),UVM_DEBUG);
    end
'''.format(_envName=GeneralDict['env_name'])
    for agent in AgentList:
        instanceByName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
        agentDecParameterList = getAgentDecParameter(agent,AgentList)
        if agent['instance_type']=='string':
            memberDeclare +='''
    {_instanceByName}_agent {_agentDecParameterList} u_{_agentName}_agent[string]    ;
    uvm_tlm_analysis_fifo #({_instanceByName}_agent_xaction{_agentDecParameterList}) {_agentName}_mon2rm_fifo;
'''.format(_instanceByName=instanceByName,_agentName=agent['agent_name'],_envName=GeneralDict['env_name'],_agentDecParameterList=agentDecParameterList)
            memberNew += "\n" + ' '*4 + '{_agentName}_mon2rm_fifo = new($sformatf("{_agentName}_mon2rm_fifo"),this) ;\n'.format(_agentName=agent['agent_name'])
            fifoConnect +='\n'
            for stringName in agent['instance_list']:
                memberNew +='''
    this.u_{_agentName}_agent[{_stringName}] = {_instanceByName}_agent{_agentDecParameterList}::type_id::create($sformatf("u_{_agentName}_agent[%s]",{_stringName}),this);
    uvm_config_db#({_instanceByName}_agent_cfg)::set(this,$sformatf("u_{_agentName}_agent[%s]",{_stringName}),"cfg",this.cfg.u_{_agentName}_agent_cfg[{_stringName}]) ;
'''.format(_instanceByName=instanceByName,_agentName=agent['agent_name'],_agentDecParameterList=agentDecParameterList,_stringName=stringName)[1:]
                fifoConnect +='''
    this.u_{_agentName}_agent[{_stringName}].mon_item_port.connect(this.{_agentName}_mon2rm_fifo.analysis_export);
    this.rm.{_agentName}_mon_item_port.connect(this.{_agentName}_mon2rm_fifo.blocking_get_export);
'''.format(_agentName=agent['agent_name'],_stringName=stringName)[1:]
        elif agent['instance_num']==1:
            memberDeclare +='''
    {_instanceByName}_agent {_agentDecParameterList} u_{_agentName}_agent    ;
    uvm_tlm_analysis_fifo #({_instanceByName}_agent_xaction{_agentDecParameterList}) {_agentName}_mon2rm_fifo;
'''.format(_instanceByName=instanceByName,_agentName=agent['agent_name'],_envName=GeneralDict['env_name'],_agentDecParameterList=agentDecParameterList)
            memberNew +='''
    {_agentName}_mon2rm_fifo = new($sformatf("{_agentName}_mon2rm_fifo"),this) ;
    this.u_{_agentName}_agent = {_instanceByName}_agent{_agentDecParameterList}::type_id::create("u_{_agentName}_agent",this);
    uvm_config_db#({_instanceByName}_agent_cfg)::set(this,"u_{_agentName}_agent","cfg",this.cfg.u_{_agentName}_agent_cfg) ;
'''.format(_instanceByName=instanceByName,_agentName=agent['agent_name'],_agentDecParameterList=agentDecParameterList)
            fifoConnect +='''
    this.u_{_agentName}_agent.mon_item_port.connect(this.{_agentName}_mon2rm_fifo.analysis_export);
    this.rm.{_agentName}_mon_item_port.connect(this.{_agentName}_mon2rm_fifo.blocking_get_export);
'''.format(_agentName=agent['agent_name'])
        else:
            memberDeclare +='''
    {_instanceByName}_agent {_agentDecParameterList} u_{_agentName}_agent[{_instanceNum}]    ;
    uvm_tlm_analysis_fifo #({_instanceByName}_agent_xaction{_agentDecParameterList}) {_agentName}_mon2rm_fifo;
'''.format(_instanceByName=instanceByName,_agentName=agent['agent_name'],_envName=GeneralDict['env_name'],_agentDecParameterList=agentDecParameterList,_instanceNum=agent['instance_num'])
            memberNew += ' '*4 + '{_agentName}_mon2rm_fifo = new($sformatf("{_agentName}_mon2rm_fifo"),this) ;\n'.format(_agentName=agent['agent_name'])
            memberNew += ' '*4 + 'foreach(this.u_{_agentName}_agent[i]) begin\n'.format(_agentName=agent['agent_name'])
            memberNew +='''
        this.u_{_agentName}_agent[i] = {_instanceByName}_agent{_agentDecParameterList}::type_id::create($sformatf("u_{_agentName}_agent[%0d]",i),this);
        uvm_config_db#({_instanceByName}_agent_cfg)::set(this,$sformatf("u_{_agentName}_agent[%0d]",i),"cfg",this.cfg.u_{_agentName}_agent_cfg[i]) ;
'''.format(_instanceByName=instanceByName,_agentName=agent['agent_name'],_agentDecParameterList=agentDecParameterList)
            memberNew += ' '*4 + 'end\n'
            fifoConnect += ' '*4 + 'foreach(this.u_{_agentName}_agent[i]) begin\n'.format(_agentName=agent['agent_name'])
            fifoConnect +='''
        this.u_{_agentName}_agent[i].mon_item_port.connect(this.{_agentName}_mon2rm_fifo.analysis_export);
        this.rm.{_agentName}_mon_item_port.connect(this.{_agentName}_mon2rm_fifo.blocking_get_export);
'''.format(_agentName=agent['agent_name'])
            fifoConnect += ' '*4 + 'end\n'
    fifoConnect +='''
    this.rm.rm_item_exp_port.connect(this.rm2scb_exp_fifo.analysis_export);
    this.scb.exp_port.connect(this.rm2scb_exp_fifo.blocking_get_export);
    this.rm.rm_item_act_port.connect(this.rm2scb_act_fifo.analysis_export);
    this.scb.act_port.connect(this.rm2scb_act_fifo.blocking_get_export);
'''
    memberDeclare +='''
    uvm_tlm_analysis_fifo #({_envName}_common_xaction{_parameterList}) rm2scb_exp_fifo;
    uvm_tlm_analysis_fifo #({_envName}_common_xaction{_parameterList}) rm2scb_act_fifo;\n
    {_envName}_rm {_parameterList} rm;
    //aa_test_reg_model	reg_model;
    tcnt_scb_base #({_envName}_common_xaction{_parameterList}) scb;
'''.format(_envName=GeneralDict['env_name'],_parameterList=parameterList)
    memberNew +='''
    rm2scb_exp_fifo = new($sformatf("rm2scb_exp_fifo"),this) ;
    rm2scb_act_fifo = new($sformatf("rm2scb_act_fifo"),this) ;\n
    this.rm = {_envName}_rm{_parameterList}::type_id::create("rm", this);
    uvm_config_db#({_envName}_env_cfg)::set(this,"rm","cfg",this.cfg) ;
    this.scb = tcnt_scb_base#({_envName}_common_xaction{_parameterList})::type_id::create("scb", this);
'''.format(_envName=GeneralDict['env_name'],_parameterList=parameterList)
    fileContext = '''{_Title}
class {_moduleName} {_classParameter} extends tcnt_env_base;

{_memberDeclare}
    {_registerParameter}

    extern         function      new(string name , uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass

function {_moduleName}::new(string name , uvm_component parent);
    super.new(name, parent);
endfunction

function void {_moduleName}::build_phase(uvm_phase phase);
    super.build_phase(phase);
{_memberNew}
endfunction

function void {_moduleName}::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //rm.reg_model = this.reg_model;
{_fifoConnect}
endfunction

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_memberDeclare=memberDeclare,_memberNew=memberNew,_fifoConnect=fifoConnect,_envName=GeneralDict['env_name'],\
    _classParameter=classParameter,_registerParameter=registerParameter)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAllEnv(GeneralDict,AgentList,PathDict):
    genEnv_fileList(GeneralDict,PathDict['env'])
    genEnv_package(GeneralDict, AgentList, PathDict['env'])
    genEnv_rm(GeneralDict,AgentList,PathDict['env_src'])
    genEnv_cfg(GeneralDict,AgentList,PathDict['env_src'])
    genEnv_env(GeneralDict,AgentList,PathDict['env_src'])

##========================================================================cfg=============================================================================================
def reGenAuthor(GeneralDict,fileName):
    global CurrTime
    with open(fileName, "r", encoding='utf-8') as f:
        Lines = f.readlines()
        f.close()
    newFile = ""
    for line in Lines:
        orgAuthor = "Heterogeneous Computing Group"
        if orgAuthor in line:
            line = line.replace(orgAuthor,GeneralDict['author'])
        if "Date" in line:
            line = "##Date         : {_CurrTime}\n".format(_CurrTime=CurrTime)
        newFile += line
    with open(fileName,"w",encoding='utf-8') as f:
        f.write(newFile)
        f.close()

def genCfg_Makefile(GeneralDict,path):
    global CurrPath
    localMakefileList = ["extern_cfg.mk","extern_declare_cfg.mk"]
    srcPath = os.path.abspath(os.path.join(CurrPath,'common_src','makefile_dir'))
    dstPath = path
    for scrpt in localMakefileList:
        srcFile = scrpt
        dstFile = scrpt
        fileIsExists = doFileCopy(srcPath,srcFile,dstPath,dstFile)
        if fileIsExists is False and scrpt=='extern_declare_cfg.mk':
            envMacro = '{_UEnvName}_{_UEnvLevel}'.format(_UEnvName=GeneralDict['env_name'].upper(),_UEnvLevel=GeneralDict['env_level'].upper())
            fileName = os.path.abspath(os.path.join(dstPath,dstFile))
            reGenAuthor(GeneralDict,fileName)
            File = open(fileName,"a",encoding='utf-8')
            UVMPrintLevel = "UVM_MEDIUM"
            if GeneralDict['env_level']=="st":
                UVMPrintLevel = "UVM_NONE"
            elif GeneralDict['env_level']=="it":
                UVMPrintLevel = "UVM_LOW"
            elif GeneralDict['env_level']=="bt":
                UVMPrintLevel = "UVM_MEDIUM"
            elif GeneralDict['env_level']=="ut":
                UVMPrintLevel = "UVM_HIGH"
            context = """
#general
pl := {_printLevel}
COVER_DEFINE = +define+{_envMacro}_FCOV
CMP_OPTIONS += +define+{_envMacro}
VRD_OPTIONS += +define+{_envMacro}
#IF_ADD_DLY_OPTIONS += +define+INTERFACE_ADD_DELAY

#vcs extern declare
#指定覆盖率 exlude文件，在extern_declare_cfg.mk中修改此变量指定
##e.g.
##vcs  >>assign the el file >>>COV_EX_OPTION = -elfile ../cfg/pred_exclude.el
##xrun >>assign the el dir  >>>COV_EX_OPTION = ../cfg/el/
COV_EX_OPTION =
COV_ADD_MERGE =

INITREG_CFG_FILE :=
#xrun extern declare
INSTANCE_NAME := 'top_tb.{_rtlInstance}'

#SYSC_COMP_OPTS += syscan -cpp g++ ../sysc/sc_add.cpp:sc_add -Mdir=${{CSRC_FILE}}
#CMP_OPTIONS += -cpp g++ -cc gcc -sysc 

""".format(_printLevel=UVMPrintLevel,_envMacro=envMacro,_rtlInstance=GeneralDict['u_rtl_top_name'])
            File.write(context[1:])
            File.close()
        if fileIsExists is False and scrpt=='extern_cfg.mk':
            fileName = os.path.abspath(os.path.join(dstPath,dstFile))
            reGenAuthor(GeneralDict,fileName)
        if scrpt=="dump_wave_cfg.tcl":
            chmodXfile(dstPath,dstFile)
    localXRUNScriptList = ['cov_xrun.cfg','dump_wave_cfg_xrun.tcl','dump_wave_cfg_xrun_indago.tcl']
    srcPath = os.path.abspath(os.path.join(CurrPath,'common_src','makefile_dir','xrun_mk'))
    dstPath = os.path.abspath(os.path.join(path,'xrun_mk'))
    for scrpt in localXRUNScriptList:
        srcFile = scrpt
        dstFile = scrpt
        fileIsExists = doFileCopy(srcPath,srcFile,dstPath,dstFile)
    localVCSScriptList = ['dump_wave_cfg_vcs.tcl']
    srcPath = os.path.abspath(os.path.join(CurrPath,'common_src','makefile_dir','vcs_mk'))
    dstPath = os.path.abspath(os.path.join(path,'vcs_mk'))
    for scrpt in localVCSScriptList:
        srcFile = scrpt
        dstFile = scrpt
        fileIsExists = doFileCopy(srcPath,srcFile,dstPath,dstFile)
    dstPath = os.path.abspath(os.path.join(path,'verif'))
    copyPrjMakefile(dstPath)
    copyPrjScript(dstPath)
    localProjectMKFile = os.path.abspath(os.path.join(dstPath,'project_cfg.mk'))
    #srcString = "SCR_PATH = $\{PROJECT_PATH\}\/src\/verif"
    srcString = "SCR_PATH = .*"
    dstString = "SCR_PATH = $\{CURR_DIR\}\/..\/cfg\/verif"
    os.system('sed -i "s/{}/{}/g" {}'.format(srcString,dstString,localProjectMKFile))

def genCfg_VcsTopCfg(GeneralDict,path):
    global CurrTime
    fileContext = '''//=========================================================
//File name    : vcs_topcfg.v
//Author       : {_authorName}
//Module name  : vcs_topcfg
//Discribution : vcs top for partiton compile
//Date         : {_CurrTime}
//=========================================================
config vcs_topcfg;
design top_tb;
partition instance top_tb.{_rtlInstance};
endconfig

'''.format(_authorName=GeneralDict['author'],_CurrTime=CurrTime,_rtlInstance=GeneralDict['u_rtl_top_name'])
    fileName = 'vcs_topcfg.v'
    genFile(path,fileName,fileContext)

def genCfg_TbfileList(GeneralDict,AgentList,path):
    ModuleName = 'tb'
    AuthorName = GeneralDict['author']
    Discribution = 'environment file list'
    FileType = 'f'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    HcBaseFileList,AgentFileList = '',''
    HcBaseFileList += '-F ../../../common/tcnt_base/tcnt_base.f\n'
    for agent in AgentList:
        if agent['instance_by']=='self':
            AgentFileList += '-F ../agent/{_agentName}_agent/{_agentName}_agent.f\n'.format(_agentName=agent['agent_name'])
        elif 'filelist_path' in agent.keys():
            AgentFileList += '-F {_filelistPath}\n'.format(_filelistPath=agent['filelist_path'])
    fileContext = '''
{_HcBaseFileList}
{_AgentFileList}
-F ../common/{_envName}_common/{_envName}_common.f
-F ../env/{_envName}_env.f
-F ../tc/tc.f
../tb/top_tb.sv

'''.format(_HcBaseFileList=HcBaseFileList,_AgentFileList=AgentFileList,_envName=GeneralDict['env_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genCfg_RTLfileList(GeneralDict,path):
    ModuleName = 'rtl'
    AuthorName = GeneralDict['author']
    Discribution = 'RTL file list'
    FileType = 'f'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    MacroForRtl = '../../../common/tcnt_base/src/tcnt_macro_for_rtl.sv'
    fileContext = '''
{_MacroForRtl}
-F ../../../common/tcnt_assertion/sva_lib.f
-F {_rtlFileList}

'''.format(_MacroForRtl=MacroForRtl,_rtlFileList=GeneralDict['rtl_list'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAllCfg(GeneralDict,AgentList,PathDict):
    genCfg_Makefile(GeneralDict,PathDict['cfg'])
    genCfg_VcsTopCfg(GeneralDict,PathDict['cfg'])
    genCfg_TbfileList(GeneralDict,AgentList,PathDict['cfg'])
    genCfg_RTLfileList(GeneralDict,PathDict['cfg'])
    copyIni(tmpPathDict['regress'])

##========================================================================script=============================================================================================
def copyIni(path):
    global CurrPath
    srcPath = os.path.abspath(os.path.join(CurrPath,'common_src','common_script'))
    dstPath = path
    iniList = ["formal.ini","regress.ini"]
    for iniFile in iniList:
        srcFile =  iniFile
        dstFile =  iniFile
        fileIsExists = doFileCopy(srcPath,srcFile,dstPath,dstFile)

##========================================================================tc=============================================================================================
def genTc_fileList(GeneralDict, path):
    ModuleName = 'tc'
    AuthorName = GeneralDict['author']
    Discribution = 'file list'
    FileType = 'f'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''
+incdir+./src
tc_pkg.sv

// ./src/tc_if.sv
// ./src/tc_define.sv
// ./src/tc_base.sv
// ./src/tc_sanity.sv

'''
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTc_package(GeneralDict, AgentList, path):
    ModuleName = 'tc_pkg'
    AuthorName = GeneralDict['author']
    Discribution = 'package'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    importAgent = ""
    for agent in AgentList:
        if agent['instance_by']=='self' or 'filelist_path' in agent.keys():
            agentName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
            importAgent += "    import {_agentName}_agent_dec::*;\n".format(_agentName=agentName)
            importAgent += "    import {_agentName}_agent_pkg::*;\n".format(_agentName=agentName)
    fileContext = '''{_Title}
`ifndef TCNT_HAD_INCLUDE_UVM_MACROS
`define TCNT_HAD_INCLUDE_UVM_MACROS
    `include "uvm_macros.svh"
`endif

`include "tc_define.sv"
`include "tc_if.sv"
package tc_pkg;

    import uvm_pkg::*;
    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tcnt_common_method::*;
    import tcnt_base_pkg::*;
{_importAgent}

    import {_envName}_dec::*;
    import {_envName}_common_pkg::*;

    import {_envName}_env_pkg::*;
    `include "tc_base.sv"
    `include "tc_sanity.sv"

endpackage

import tc_pkg::*;

`endif

'''.format(_Title=Title,_envName=GeneralDict['env_name'],_importAgent=importAgent)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTc_define(GeneralDict,AgentList, path):
    ModuleName = 'tc_define'
    AuthorName = GeneralDict['author']
    Discribution = 'micro define for TC'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    seqDefine = ''
    for agent in AgentList:
        if agent['agent_mode']=='master':
            seqDefine += '`define seq_{_agentName}(tc) ``tc``__seq_{_agentName}\n'.format(_agentName=agent['agent_name'])
    fileContext = '''{_Title}
{_seqDefine}

`endif

'''.format(_Title=Title,_seqDefine=seqDefine)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTc_if(GeneralDict,AgentList, path):
    ModuleName = 'tc_if'
    AuthorName = GeneralDict['author']
    Discribution = 'virtual interface for tc/rm, use to force or probe'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''{_Title}

interface tc_if(input clk);
    logic rst_n;
    //logic force_xxx;
    //logic probe_xxx;
endinterface

`endif

'''.format(_Title=Title)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTc_base(GeneralDict,AgentList,path):
    ModuleName = 'tc_base'
    AuthorName = GeneralDict['author']
    Discribution = 'TC basic'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    defaultSeqFactory = ''
    if "env_parameter" in GeneralDict.keys():
        parameterList = "#("
        for params in GeneralDict['env_parameter']:
            parameterList += ".{_params}({_envName}_dec::{_params}),".format(_params=params,_envName=GeneralDict['env_name'])
        parameterList = parameterList[:-1]
        parameterList += ")"
    else:
        parameterList = ""
    for agent in AgentList:
        if agent['agent_mode']=='master':
            if agent['instance_type']=='string':
                for stringName in agent['instance_list']:
                    defaultSeqFactory +='    uvm_config_db#(uvm_object_wrapper)::set(this, $sformatf("env.u_{_agentName}_agent[%s].sqr.main_phase",{_stringName})  , "default_sequence", {_agentName}_agent_default_sequence::type_id::get());\n'.format(_agentName=agent['agent_name'],_stringName=stringName)
            elif agent['instance_num']==1:
                defaultSeqFactory +='    uvm_config_db#(uvm_object_wrapper)::set(this, "env.u_{_agentName}_agent.sqr.main_phase"  , "default_sequence", {_agentName}_agent_default_sequence::type_id::get());\n'.format(_agentName=agent['agent_name'])
            else:
                for loop_i in range(agent['instance_num']):
                    defaultSeqFactory +='    uvm_config_db#(uvm_object_wrapper)::set(this, "env.u_{_agentName}_agent[{_loopI}].sqr.main_phase"  , "default_sequence", {_agentName}_agent_default_sequence::type_id::get());\n'.format(_agentName=agent['agent_name'],_loopI=loop_i)

    fileContext = '''{_Title}
`define TC_NAME {_moduleName}

class `TC_NAME extends tcnt_test_base;

    virtual tc_if vif;
    {_envName}_env {_parameterList} env;

 	///aa_test_reg_model   reg_model;
 	///aa_test_reg_adapter reg_adapter;

    function new(string name = \"`TC_NAME\", uvm_component parent = null);
        super.new(name,parent);
    endfunction
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    `uvm_component_utils(`TC_NAME)
endclass

function void `TC_NAME::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual tc_if)::get(this, "", "vif", vif)) begin
        `uvm_fatal(get_type_name(),$sformatf("virtual interface must be set for vif(tc_if)!!!"))
    end
    this.env  =  {_envName}_env{_parameterList}::type_id::create("env", this);

 	///reg_model = aa_test_reg_model::type_id::create("reg_model",this);
 	///reg_model.configure(null, "");
 	///reg_model.build();
 	///reg_model.lock_model();
 	///reg_model.reset();
    ///reg_model.set_hdl_path_root("top_tb.dut");
 	///env.reg_model = this.reg_model;
 	///reg_adapter = new("reg_adapter");

    //factory default_sequence
{_defaultSeqFactory}
endfunction
function void `TC_NAME::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ///reg_model.default_map.set_sequencer(env.xxx_agt.sqr, reg_adapter);
    ///reg_model.default_map.set_auto_predict(1);
endfunction

function void `TC_NAME::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction

task `TC_NAME::main_phase(uvm_phase phase);
    super.main_phase(phase);
    //@(posedge vif.clk);
    //@(posedge vif.rst_n);
    //vif.rst_n = xx;
endtask

`undef TC_NAME

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_envName=GeneralDict['env_name'],_parameterList=parameterList,_defaultSeqFactory=defaultSeqFactory)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTc_sanity(GeneralDict,AgentList,path):
    ModuleName = 'tc_sanity'
    AuthorName = GeneralDict['author']
    Discribution = 'sanity'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    defaultSeq,seqOverride,defaultSeqFactory,setStartSend = '','','',''

    for agent in AgentList:
        if agent['agent_mode']=='master':
            defaultSeq +='''
class `seq_{_agentName}(`TC_NAME) extends {_agentName}_agent_default_sequence;
    int start_send=0;
    function  new(string name= `"`seq_{_agentName}(`TC_NAME)`");
        super.new(name);
    endfunction

    virtual task body();
        //wait for start
        while(this.start_send==0) begin
            tcnt_realtime::delay_ns(100);
            void'(uvm_config_db#(int)::get(null, get_full_name(), "start_send", start_send));
        end
        repeat(10) begin
            `uvm_create(req)
            //vodi'(req.randomize() with {{req.xxx inside {{[xxx:xx]}};
            //                             req.yyy == yyy;}});
            void'(req.randomize());
            `uvm_send(req)
        end
        tcnt_realtime::delay_us(100);
    endtask

    `uvm_object_utils_begin(`seq_{_agentName}(`TC_NAME))
        `uvm_field_int(start_send,UVM_ALL_ON)
    `uvm_object_utils_end
endclass
'''.format(_agentName=agent['agent_name'])
            seqOverride += "    //set_type_override_by_type({_agentName}_agent_default_sequence::get_type(), `seq_{_agentName}(`TC_NAME)::get_type());\n".format(_agentName=agent['agent_name'])
            if agent['instance_type']=='string':
                for stringName in agent['instance_list']:
                    defaultSeqFactory +='    //uvm_config_db#(uvm_object_wrapper)::set(this, $sformatf("env.u_{_agentName}_agent[%s].sqr.main_phase",{_stringName})  , "default_sequence", `seq_{_agentName}(`TC_NAME)::type_id::get());\n'.format(_agentName=agent['agent_name'],_stringName=stringName)
                    setStartSend += '    //uvm_config_db#(int)::set(this, $sformatf("env.u_{_agentName}_agent[%s].sqr.*",{_stringName})  , "start_send", 1);\n'.format(_agentName=agent['agent_name'],_stringName=stringName)
            elif agent['instance_num']==1:
                defaultSeqFactory +='    //uvm_config_db#(uvm_object_wrapper)::set(this, "env.u_{_agentName}_agent.sqr.main_phase"  , "default_sequence", `seq_{_agentName}(`TC_NAME)::type_id::get());\n'.format(_agentName=agent['agent_name'])
                setStartSend += '    //uvm_config_db#(int)::set(this, "env.u_{_agentName}_agent.sqr.*"  , "start_send", 1);\n'.format(_agentName=agent['agent_name'])
            else:
                for loop_i in range(agent['instance_num']):
                    defaultSeqFactory +='    //uvm_config_db#(uvm_object_wrapper)::set(this, "env.u_{_agentName}_agent[{_loopI}].sqr.main_phase"  , "default_sequence", `seq_{_agentName}(`TC_NAME)::type_id::get());\n'.format(_agentName=agent['agent_name'],_loopI=loop_i)
                    setStartSend += '    //uvm_config_db#(int)::set(this, "env.u_{_agentName}_agent[{_loopI}].sqr.*"  , "start_send", 1);\n'.format(_agentName=agent['agent_name'],_loopI=loop_i)

    fileContext = '''{_Title}
`define TC_NAME {_moduleName}
{_defaultSeq}
class `TC_NAME extends tc_base;

    function new(string name = "`TC_NAME", uvm_component parent = null);
        super.new(name,parent);
    endfunction
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
    extern virtual task reset_phase(uvm_phase phase);
    extern virtual task configure_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    extern virtual task shutdown_phase(uvm_phase phase);
    `uvm_component_utils(`TC_NAME)
endclass

function void `TC_NAME::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //default_sequence set & override 2mux1
    //>>>>
    //default_sequence override
{_seqOverride}
    //set default_sequence
{_defaultSeqFactory}
endfunction

function void `TC_NAME::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction

task `TC_NAME::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    tcnt_realtime::delay_us(100);
    phase.drop_objection(this);
endtask

task `TC_NAME::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    phase.raise_objection(this);
    tcnt_realtime::delay_us(100);
    phase.drop_objection(this);
endtask

task `TC_NAME::main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);
    tcnt_realtime::delay_us(100);
{_setStartSend}
    tcnt_realtime::delay_ms(1);
    phase.drop_objection(this);
endtask

task `TC_NAME::shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    phase.raise_objection(this);
    tcnt_realtime::delay_us(100);
    phase.drop_objection(this);
endtask

`undef TC_NAME

`endif

'''.format(_Title=Title,_moduleName=ModuleName,_defaultSeq=defaultSeq,_seqOverride=seqOverride,_defaultSeqFactory=defaultSeqFactory,_setStartSend=setStartSend)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTc_gentc_py(GeneralDict,path):
    ModuleName = 'GenTc'
    AuthorName = GeneralDict['author']
    FileType = 'py'
    fileContext = r'''#!/usr/bin/python
# coding=utf-8
import os, sys, time
import argparse

if __name__=="__main__":
    parser = argparse.ArgumentParser(description='Input parameters to this script')
    parser.add_argument("--tc_old", type=str, default="tc_sanity", help='the tc name which the new tc copy by ,default is tc_sanity')
    parser.add_argument("--tc_new", type=str, default="tc_By_GenTc", help='the new tc name ,default is tc_By_GenTc')
    parser.add_argument("--author", type=str, default="{_authorName}", help='the author name, default is "{_authorName}"')
    parser.add_argument("--tc_list", type=str, default="tc.f", help='the filelist which the new tc appended to, default is tc.f')
    parser.add_argument("--tc_pkg", type=str, default="tc_pkg.sv", help='the package which the new tc appended to, default is tc_pkg.sv')

    args = parser.parse_args()
    TcOldName = args.tc_old
    TcNewName = args.tc_new
    Author = args.author
    TcList = args.tc_list
    TcPkg = args.tc_pkg
    CurrTime = time.strftime("%Y-%m-%d",time.localtime())

    TcPath = sys.path[0]
    TcOld = os.path.abspath(os.path.join(TcPath,'src','{{_TcOldName}}.sv'.format(_TcOldName=TcOldName)))
    TcNew = os.path.abspath(os.path.join(TcPath,'src','{{_TcNewName}}.sv'.format(_TcNewName=TcNewName)))
    os.system('cp {{_TcOld}} {{_TcNew}}'.format(_TcOld=TcOld,_TcNew=TcNew))
    #替换头注释、宏声明、TC_NAME
    os.system('sed -i "s/\/\/File name    :.*/\/\/File name    : {{_TcNewName}}.sv/g" {{_TcNew}}'.format(_TcNewName=TcNewName,_TcNew=TcNew))
    os.system('sed -i "s/\/\/Author       :.*/\/\/Author       : {{_Author}}/g" {{_TcNew}}'.format(_Author=Author,_TcNew=TcNew))
    os.system('sed -i "s/\/\/Module name  :.*/\/\/Module name  : {{_TcNewName}}/g" {{_TcNew}}'.format(_TcNewName=TcNewName,_TcNew=TcNew))
    os.system('sed -i "s/\/\/Discribution :.*/\/\/Discribution : {{_TcNewName}}/g" {{_TcNew}}'.format(_TcNewName=TcNewName,_TcNew=TcNew))
    os.system('sed -i "s/\/\/Date         :.*/\/\/Date         : {{_CurrTime}}/g" {{_TcNew}}'.format(_CurrTime=CurrTime,_TcNew=TcNew))
    os.system('sed -i "s/\`ifndef.*_SV.*/\`ifndef {{_UTcNewName}}__SV/g" {{_TcNew}}'.format(_UTcNewName=TcNewName.upper(),_TcNew=TcNew))
    os.system('sed -i "s/\`define.*_SV.*/\`define {{_UTcNewName}}__SV/g" {{_TcNew}}'.format(_UTcNewName=TcNewName.upper(),_TcNew=TcNew))
    os.system('sed -i "s/\`define TC_NAME.*/\`define TC_NAME {{_TcNewName}}/g" {{_TcNew}}'.format(_TcNewName=TcNewName,_TcNew=TcNew))
    #添加file到filelist
    FileList = os.path.abspath(os.path.join(TcPath,'{{_FileList}}'.format(_FileList=TcList)))
    file = open(FileList,'a')
    file.write('// ./src/{{_TcNewName}}.sv\n'.format(_TcNewName=TcNewName))
    file.close
    #添加file到package
    PkgFile = os.path.abspath(os.path.join(TcPath,'{{_PkgFile}}'.format(_PkgFile=TcPkg)))
    newPkgFileLine = ""
    with open(PkgFile,"r") as file:
        for line in file:
            if line.replace(" ","").replace("\n","")=="endpackage":
                newPkgFileLine += '    `include "{{_TcNewName}}.sv"\n'.format(_TcNewName=TcNewName)
                newPkgFileLine += line
            else:
                newPkgFileLine += line
        file.close()
    file = open(PkgFile,'w')
    file.write(newPkgFileLine)
    file.close

'''.format(_authorName=AuthorName)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)
    chmodXfile(path,fileName)

def genAllTc(GeneralDict,AgentList,PathDict):
    genTc_fileList(GeneralDict,PathDict['tc'])
    genTc_package(GeneralDict, AgentList, PathDict['tc'])
    genTc_define(GeneralDict,AgentList,PathDict['tc_src'])
    genTc_if(GeneralDict,AgentList,PathDict['tc_src'])
    genTc_base(GeneralDict,AgentList,PathDict['tc_src'])
    genTc_sanity(GeneralDict,AgentList,PathDict['tc_src'])
    genTc_gentc_py(GeneralDict,PathDict['tc'])

##========================================================================tb=============================================================================================
def genTb_genWave(GeneralDict, path):
    ModuleName = 'gen_wave'
    AuthorName = GeneralDict['author']
    Discribution = 'generate wave(fsdb)'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''{_Title}
longint seed_value;
string wave_type;
string fsdb_name="default";
string tc_name="";
string mode="";
int dly_100us_dump_fsdb=0;
string sdf_path;

initial
begin
    void'($value$plusargs("wave_type=%s",wave_type));
    void'($value$plusargs("ntb_random_seed=%d",seed_value));
    void'($value$plusargs("UVM_TESTNAME=%s",tc_name));
    void'($value$plusargs("TEST_MODE=%s",mode));
    if($test$plusargs("gen_wave=rtl")) begin
        fsdb_name = $sformatf("%s/wave/%s_%0d_rtl.fsdb",mode,tc_name,seed_value);
    end
    if($test$plusargs("gen_wave=setup")) begin
        fsdb_name = $sformatf("%s/wave/%s_%0d_setup.fsdb",mode,tc_name,seed_value);
    end
    if($test$plusargs("gen_wave=hold")) begin
        fsdb_name = $sformatf("%s/wave/%s_%0d_hold.fsdb",mode,tc_name,seed_value);
    end
    if($test$plusargs("gen_wave=gate")) begin
        fsdb_name = $sformatf("%s/wave/%s_%0d_gate.fsdb",mode,tc_name,seed_value);
    end
    `ifndef NO_FSDB
    if(wave_type=="fsdb") begin
	    $fsdbDumpfile(fsdb_name);
	    $fsdbDumpvars(0,"top_tb");
	    $fsdbDumpMDA(0,"top_tb");
        if($value$plusargs("dly_100us_dump_fsdb=%0d",dly_100us_dump_fsdb)) begin
            `uvm_info("DUMP_FSDB",$sformatf("DUMP FSDB after %0f ms",dly_100us_dump_fsdb/10),UVM_NONE)
            if(dly_100us_dump_fsdb!=0) begin
                $fsdbDumpoff;
                repeat(dly_100us_dump_fsdb) begin
                    tcnt_realtime::delay_us(100);
                end
                $fsdbDumpon;
            end
        end
    end
    `endif
end

`endif

'''.format(_Title=Title)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTb_readSdf(GeneralDict, path):
    ModuleName = 'read_sdf'
    AuthorName = GeneralDict['author']
    Discribution = 'read the sdf'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''{_Title}

`ifdef RTL_SIM
initial begin
    $display("doing rtl simulation");
end
`endif

`ifdef GATE_SIM
initial begin
    $display("doing gate simulation without sdf");
end
`endif


`ifdef MAX_SDF
initial begin
    $display("doing net simulation with setup sdf");
end
initial begin
    if(!($value$plusargs("sdf_path=%s",sdf_path))) begin
        sdf_path = "TODO";
        if(sdf_path=="TODO") begin
            `uvm_fatal("SDF_ANNOTATE",$sformatf("HAVE NOT SDF PATH ASSIGN, please give a default path"))
        end
        `uvm_info("SDF_ANNOTATE",$sformatf("HAVE NOT SDF PATH ASSIGN, use the default sdf path : ",sdf_path),UVM_NONE)
    end
    $sdf_annotate(sdf_path,//""/*sdf path*/,
                  top_tb.dut,
                  /*config_file*/,
                  "max_sdf.log"/*"Log_file"*/,
                  "MAXIMUM"/*"(Mtm_spec):MINIMUM,TYPICAL,MAXIMUM,TOOL_CONTROL"*/,
                  /*"Scale_factors"----min:type:max=1.0:1.0:1.0*/,
                  "FROM_MAXIMUM"/*"(Scale_type)FROM_MINIMUM,FROM_TYPICAL,FROM_MAXIMUM,FROM_MTM"*/
                 );
end
`endif

`ifdef MIN_SDF
initial begin
    $display("doing net simulation with hold sdf");
end
initial begin
    if(!($value$plusargs("sdf_path=%s",sdf_path))) begin
        sdf_path = "TODO";
        if(sdf_path=="TODO") begin
            `uvm_fatal("SDF_ANNOTATE",$sformatf("HAVE NOT SDF PATH ASSIGN, please give a default path"))
        end
        `uvm_info("SDF_ANNOTATE",$sformatf("HAVE NOT SDF PATH ASSIGN, use the default sdf path : ",sdf_path),UVM_NONE)
    end
    $sdf_annotate(sdf_path,//""/*sdf path*/,
                  top_tb.dut,
                  /*config_file*/,
                  "min_sdf.log"/*"Log_file"*/,
                  "MINIMUM"/*"(Mtm_spec):MINIMUM,TYPICAL,MAXIMUM,TOOL_CONTROL"*/,
                  /*"Scale_factors"----min:type:max=1.0:1.0:1.0*/,
                  "FROM_MINIMUM"/*"(Scale_type)FROM_MINIMUM,FROM_TYPICAL,FROM_MAXIMUM,FROM_MTM"*/
                 );
end
`endif

`ifdef TYPICAL_SDF
initial begin
    $display("doing net simulation with typical sdf");
end
initial begin
    if(!($value$plusargs("sdf_path=%s",sdf_path))) begin
        sdf_path = "TODO";
        if(sdf_path=="TODO") begin
            `uvm_fatal("SDF_ANNOTATE",$sformatf("HAVE NOT SDF PATH ASSIGN, please give a default path"))
        end
        `uvm_info("SDF_ANNOTATE",$sformatf("HAVE NOT SDF PATH ASSIGN, use the default sdf path : ",sdf_path),UVM_NONE)
    end
    $sdf_annotate(sdf_path,//""/*sdf path*/,
                  top_tb.dut,
                  /*config_file*/,
                  "typical_sdf.log"/*"Log_file"*/,
                  "TYPICAL"/*"(Mtm_spec):MINIMUM,TYPICAL,MAXIMUM,TOOL_CONTROL"*/,
                  /*"Scale_factors"----min:type:max=1.0:1.0:1.0*/,
                  "FROM_TYPICAL"/*"(Scale_type)FROM_MINIMUM,FROM_TYPICAL,FROM_MAXIMUM,FROM_MTM"*/
                 );
end
`endif

`endif

'''.format(_Title=Title)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTb_dutInstance(GeneralDict,AgentList,path):
    ModuleName = 'dut_inst'
    AuthorName = GeneralDict['author']
    Discribution = 'DUT instance'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    signalDeclare,signalConnect = '',''
    signalConnect += '    //clock & reset\n'
    signalConnect += ' '*4 + '.' + 'clk'.ljust(20) + ' ( ' + 'clk'.ljust(20) + ' ),\n'
    signalConnect += ' '*4 + '.' + 'rst_n'.ljust(20) + ' ( ' + 'tc_if.rst_n'.ljust(20) + ' ),\n'
    for agent in AgentList:
        signalDeclare += '//{_agentName}\n'.format(_agentName=agent['agent_name'])
        signalConnect += '    //{_agentName}\n'.format(_agentName=agent['agent_name'])
        instanceByName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
        tmpAgent = agent
        if agent["instance_by"]!='self':
            for tmp in AgentList:
                if tmp["agent_name"]==agent["instance_by"]:
                    tmpAgent = tmp
                    break
        parameterDict = tmpAgent['parameter'] if "parameter" in tmpAgent.keys() else {}
        if agent['instance_num']==1:
            for signal in agent['dut_interface_list0']:
                #这里要求接口信号一定时小写，paramter一定是大写，如果接口信号有有内容和parameter匹配并且大小写一致，此处改写会出错
                if len(parameterDict.keys())==0:
                    tmpSignal = signal
                else:
                    for params in parameterDict.keys():
                        tmpSignal = re.sub(params,"{}_agent_dec::{}".format(instanceByName,params),signal)
                #tmpSignal = signal
                if re.search(re.compile(r'input'),tmpSignal):
                    signalDeclare += re.compile(r'.* bit ').sub('reg ',tmpSignal).ljust(35)+';\n'
                elif re.search(re.compile(r'output'),tmpSignal):
                    signalDeclare += re.compile(r'.* bit ').sub('wire ',tmpSignal).ljust(35)+';\n'
                else:#inout
                    signalDeclare += re.compile(r'.* bit ').sub('reg ',tmpSignal).ljust(35)+';\n'
                signalName = re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',tmpSignal)).replace(' ','').ljust(20)
                signalConnect += ' '*4 + '.' + signalName + ' ( ' + signalName + ' ),\n'
        else:
            for loop_i in range(agent['instance_num']):
                signalConnect += '    ////{_loopI}\n'.format(_loopI=loop_i)
                for signal in agent['dut_interface_list{_loopI}'.format(_loopI=loop_i)]:
                    #这里要求接口信号一定时小写，paramter一定是大写，如果接口信号有有内容和parameter匹配并且大小写一致，此处改写会出错
                    if len(parameterDict.keys())==0:
                        tmpSignal = signal
                    else:
                        for params in parameterDict.keys():
                            tmpSignal = re.sub(params,"{}_agent_dec::{}".format(instanceByName,params),signal)
                    #tmpSignal = signal
                    if re.search(re.compile(r'input'),tmpSignal):
                        signalDeclare += re.compile(r'.* bit ').sub('reg ',tmpSignal).ljust(35)+';\n'
                    elif re.search(re.compile(r'output'),tmpSignal):
                        signalDeclare += re.compile(r'.* bit ').sub('wire ',tmpSignal).ljust(35)+';\n'
                    else:#inout
                        signalDeclare += re.compile(r'.* bit ').sub('reg ',tmpSignal).ljust(35)+';\n'
                    signalName = re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',tmpSignal)).replace(' ','').ljust(20)
                    signalConnect += ' '*4 + '.' + signalName + ' ( ' + signalName + ' ),\n'
    signalConnect = signalConnect[:-2]
    fileContext = '''{_Title}
{_signalDeclare}
{_rtlName} {_rtlInstance} (
{_signalConnect}
);

`endif

'''.format(_Title=Title,_signalDeclare=signalDeclare,_rtlName=GeneralDict['rtl_top_name'],_rtlInstance=GeneralDict['u_rtl_top_name'],_signalConnect=signalConnect)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTb_agentConnect(GeneralDict,AgentList,path):
    for agent in AgentList:
        ModuleName = '{_agentName}_connect'.format(_agentName=agent['agent_name'])
        AuthorName = GeneralDict['author']
        Discribution = '{_agentName} Interface connection macro'.format(_agentName=agent['agent_name'])
        FileType = 'sv'
        Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
        instanceByName = agent['agent_name'] if agent['instance_by']=='self' else agent['instance_by']
        agentDecParameterList = getAgentDecParameter(agent,AgentList)
        agentSignalList,dutSignalList = [],[]
        for signal in agent['agent_interface_list']:
            agentSignalList.append(re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',signal)).replace(' ',''))
        ifInstance,signalConnect,subSignalConnect = '','',''
        if agent['instance_type']=='string':
            for loop_i in range(agent['instance_num']):
                stringName = agent['instance_list'][loop_i]
                ifInstance += '''
    {_instanceByName}_agent_interface {_agentDecParameterList} ``U_IF_NAME``__{_UstringName} (clk,tc_if.rst_n); \\
    initial begin \\
        uvm_config_db#(virtual {_instanceByName}_agent_interface{_agentDecParameterList})::set(null,$sformatf(`"*AGENT_PATH[%s]*`",{_stringName}), "vif", ``U_IF_NAME``__{_UstringName}); \\
    end \\'''.format(_instanceByName=instanceByName,_agentDecParameterList=agentDecParameterList,_stringName=stringName,_UstringName=stringName[1:-1].upper())
                dutSignalList = []
                for signal in agent['dut_interface_list{_loopI}'.format(_loopI=loop_i)]:
                    dutSignalList.append(re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',signal)).replace(' ',''))
                if len(agentSignalList)!=len(dutSignalList):
                    print(str(sys._getframe().f_lineno) + "@" + 'WARN::::the dutSignalList{_loopI}({_dutSignalList}) is differ from agentSignalList({_agentSignalList})'.format(_loopI=loop_i,_dutSignalList=dutSignalList,_agentSignalList=agentSignalList))
                signalConnect += ' '*8 + '//{_agentName}_{_loopI} \\\n'.format(_agentName=agent['agent_name'],_loopI=loop_i)
                subSignalConnect += ' '*8 + '//{_agentName}_{_loopI} \\\n'.format(_agentName=agent['agent_name'],_loopI=loop_i)
                for i in range(len(dutSignalList)):
                    signal = agent['dut_interface_list{_loopI}'.format(_loopI=loop_i)][i]
                    if re.search(re.compile(r'input'),signal):
                        signalConnect += ' '*8 + 'force RTL_PATH.{_mySignal} = ``U_IF_NAME``__{_UstringName}.{_instanceSignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i],_UstringName=stringName[1:-1].upper())
                    elif re.search(re.compile(r'output'),signal):
                        signalConnect += ' '*8 + 'force ``U_IF_NAME``__{_UstringName}.{_instanceSignal} = RTL_PATH.{_mySignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i],_UstringName=stringName[1:-1].upper())
                    else:#inout
                        signalConnect += ' '*8 + 'force RTL_PATH.{_mySignal} = ``U_IF_NAME``__{_UstringName}.{_instanceSignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i],_UstringName=stringName[1:-1].upper())
                    subSignalConnect += ' '*8 + 'force ``U_IF_NAME``__{_UstringName}.{_instanceSignal} = RTL_PATH.{_mySignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i],_UstringName=stringName[1:-1].upper())
            ifInstance = ifInstance[1:]
        elif agent['instance_num']==1:
            dutSignalList = []
            for signal in agent['dut_interface_list0']:
                dutSignalList.append(re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',signal)).replace(' ',''))
            if len(agentSignalList)!=len(dutSignalList):
                print(str(sys._getframe().f_lineno) + "@" + 'WARN::::the dutSignalList({_dutSignalList}) is differ from agentSignalList({_agentSignalList})'.format(_dutSignalList=dutSignalList,_agentSignalList=agentSignalList))
            ifInstance += '''    {_instanceByName}_agent_interface {_agentDecParameterList} U_IF_NAME (clk,tc_if.rst_n); \\
    initial begin \\
        uvm_config_db#(virtual {_instanceByName}_agent_interface{_agentDecParameterList})::set(null,`"*AGENT_PATH*`", "vif", U_IF_NAME); \\
    end \\'''.format(_instanceByName=instanceByName,_agentDecParameterList=agentDecParameterList)
            for i in range(len(dutSignalList)):
                signal = agent['dut_interface_list0'][i]
                if re.search(re.compile(r'input'),signal):
                    signalConnect += ' '*8 + 'force RTL_PATH.{_mySignal} = U_IF_NAME.{_instanceSignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i])
                elif re.search(re.compile(r'output'),signal):
                    signalConnect += ' '*8 + 'force U_IF_NAME.{_instanceSignal} = RTL_PATH.{_mySignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i])
                else:#inout
                    signalConnect += ' '*8 + 'force RTL_PATH.{_mySignal} = U_IF_NAME.{_instanceSignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i])
                subSignalConnect += ' '*8 + 'force U_IF_NAME.{_instanceSignal} = RTL_PATH.{_mySignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i])
        else:
            ifInstance += '''    generate \\
        for(genvar {_agentName}_i=0; {_agentName}_i<{_instanceNum}; {_agentName}_i++) begin: ``U_IF_NAME``_LOOP \\
            {_instanceByName}_agent_interface {_agentDecParameterList} U_IF_NAME (clk,tc_if.rst_n); \\
            initial begin \\
                uvm_config_db#(virtual {_instanceByName}_agent_interface{_agentDecParameterList})::set(null,$sformatf(`"*AGENT_PATH[%0d]*`",{_agentName}_i), "vif", ``U_IF_NAME``_LOOP[{_agentName}_i].U_IF_NAME); \\
            end \\
        end \\
    endgenerate \\'''.format(_agentName=agent['agent_name'],_instanceNum=agent['instance_num'],_instanceByName=instanceByName,_agentDecParameterList=agentDecParameterList)
            for loop_i in range(agent['instance_num']):
                dutSignalList = []
                for signal in agent['dut_interface_list{_loopI}'.format(_loopI=loop_i)]:
                    dutSignalList.append(re.compile(r'\[.*\]').sub('',re.compile(r'.* bit ').sub('',signal)).replace(' ',''))
                if len(agentSignalList)!=len(dutSignalList):
                    print(str(sys._getframe().f_lineno) + "@" + 'WARN::::the dutSignalList{_loopI}({_dutSignalList}) is differ from agentSignalList({_agentSignalList})'.format(_loopI=loop_i,_dutSignalList=dutSignalList,_agentSignalList=agentSignalList))
                signalConnect += ' '*8 + '//{_agentName}_{_loopI} \\\n'.format(_agentName=agent['agent_name'],_loopI=loop_i)
                subSignalConnect += ' '*8 + '//{_agentName}_{_loopI} \\\n'.format(_agentName=agent['agent_name'],_loopI=loop_i)
                for i in range(len(dutSignalList)):
                    signal = agent['dut_interface_list{_loopI}'.format(_loopI=loop_i)][i]
                    if re.search(re.compile(r'input'),signal):
                        signalConnect += ' '*8 + 'force RTL_PATH.{_mySignal} = ``U_IF_NAME``_LOOP[{_loopI}].U_IF_NAME.{_instanceSignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i],_loopI=loop_i)
                    elif re.search(re.compile(r'output'),signal):
                        signalConnect += ' '*8 + 'force ``U_IF_NAME``_LOOP[{_loopI}].U_IF_NAME.{_instanceSignal} = RTL_PATH.{_mySignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i],_loopI=loop_i)
                    else:#inout
                        signalConnect += ' '*8 + 'force RTL_PATH.{_mySignal} = ``U_IF_NAME``_LOOP[{_loopI}].U_IF_NAME.{_instanceSignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i],_loopI=loop_i)
                    subSignalConnect += ' '*8 + 'force ``U_IF_NAME``_LOOP[{_loopI}].U_IF_NAME.{_instanceSignal} = RTL_PATH.{_mySignal}; \\\n'.format(_mySignal=dutSignalList[i],_instanceSignal=agentSignalList[i],_loopI=loop_i)
        signalConnect = signalConnect[:-1]
        subSignalConnect = subSignalConnect[:-1]
        fileContext = '''{_Title}
`define {_UEnvName}__{_ModuleNameUpper}(U_IF_NAME,AGENT_PATH,RTL_PATH) \\
{_ifInstance}
    `ifdef {_UEnvName}_{_UEnvLevel} \\
    initial begin \\
{_signalConnect}
    end \\
    `else \\
    initial begin \\
{_subSignalConnect}
    end \\
    `endif

`endif
'''.format(_Title=Title,_UEnvName=GeneralDict['env_name'].upper(),_UEnvLevel=GeneralDict['env_level'].upper(),_ModuleNameUpper=ModuleName.upper(),_signalConnect=signalConnect,_subSignalConnect=subSignalConnect,_ifInstance=ifInstance)
        fileName = ModuleName+'.'+FileType
        genFile(path,fileName,fileContext)

def genTb_dutConnect(GeneralDict,AgentList,path):
    ModuleName = '{_envName}_connect'.format(_envName=GeneralDict['env_name'])
    AuthorName = GeneralDict['author']
    Discribution = '{_envName} connection macro'.format(_envName=GeneralDict['env_name'])
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    includeContext, macroConnect = '',''
    for agent in AgentList:
        includeContext += '`include "../../../{_envLevel}/{_envName}/tb/{_agentName}_connect.sv"\n'.format(_envLevel=GeneralDict['env_level'],_envName=GeneralDict['env_name'],_agentName=agent['agent_name'])
        macroConnect += ' '*4 + '`{_UEnvName}__{_UAgentName}_CONNECT(u_{_envName}__{_agentName}_if, ENV_PATH.u_{_agentName}_agent, RTL_PATH) \\\n'.format(_UEnvName=GeneralDict['env_name'].upper(),_UAgentName=agent['agent_name'].upper(),_envName=GeneralDict['env_name'],_agentName=agent['agent_name'])
    macroConnect = macroConnect[:-2]
    fileContext = '''{_Title}
{_includeContext}
`define {_UEnvName}_CONNECT(ENV_PATH,RTL_PATH) \\
{_macroConnect}

`endif
'''.format(_Title=Title,_UEnvName=GeneralDict['env_name'].upper(),_includeContext=includeContext,_macroConnect=macroConnect)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTc_ifConnect(GeneralDict,AgentList,path):
    ModuleName = 'tc_if_connect'
    AuthorName = GeneralDict['author']
    Discribution = 'tc virtual connection for force/probe'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''{_Title}
tc_if tc_if(clk);
initial begin
    uvm_config_db#(virtual tc_if)::set(null, "uvm_test_top", "vif", tc_if);
    uvm_config_db#(virtual tc_if)::set(null, "uvm_test_top*.rm", "vif", tc_if);
end

`endif
'''.format(_Title=Title)
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genTb_TopTb(GeneralDict,AgentList,path):
    ModuleName = 'top_tb'
    AuthorName = GeneralDict['author']
    Discribution = 'testbench top'
    FileType = 'sv'
    Title = genTitle(AuthorName,ModuleName,FileType,Discribution)
    fileContext = '''{_Title}
`timescale 1ns/1ps

`ifndef TCNT_HAD_INCLUDE_UVM_MACROS
`define TCNT_HAD_INCLUDE_UVM_MACROS
    `include "uvm_macros.svh"
`endif

`ifndef TCNT_HAD_IMPORT_UVM_PKG
`define TCNT_HAD_IMPORT_UVM_PKG
    import uvm_pkg::*;
`endif

`include "../../../common/tcnt_base/src/tcnt_clk_gen.sv"

module top_tb;

    import tcnt_realtime::*;
    import tcnt_dec_base::*;
    import tc_pkg::*;

    reg clk;

    `CLK_GEN(clk,200)
    `RST_GEN(tc_if.rst_n,100)

    `include "../tb/dut_inst.sv"
    `include "../tb/tc_if_connect.sv"
    `include "../../../{_envLevel}/{_envName}/tb/{_envName}_connect.sv"
    `{_UEnvName}_CONNECT(env,top_tb.{_rtlInstance})

    initial begin
       run_test();
    end

    //`include "../tb/gen_wave.sv"
    `include "../tb/read_sdf.sv"

endmodule
`endif

'''.format(_Title=Title,_envLevel=GeneralDict['env_level'],_envName=GeneralDict['env_name'],_UEnvName=GeneralDict['env_name'].upper(),_rtlInstance=GeneralDict['u_rtl_top_name'])
    fileName = ModuleName+'.'+FileType
    genFile(path,fileName,fileContext)

def genAllTb(GeneralDict,AgentList,PathDict):
    genTb_genWave(GeneralDict,PathDict['tb'])
    genTb_readSdf(GeneralDict,PathDict['tb'])
    genTb_dutInstance(GeneralDict,AgentList,PathDict['tb'])
    genTb_agentConnect(GeneralDict,AgentList,PathDict['tb'])
    genTb_dutConnect(GeneralDict,AgentList,PathDict['tb'])
    genTc_ifConnect(GeneralDict,AgentList,PathDict['tb'])
    genTb_TopTb(GeneralDict,AgentList,PathDict['tb'])

##========================================================================sim=============================================================================================
def genSim_makefile(GeneralDict,path):
    global CurrTime
    fileContext = '''##=========================================================
##File name    : Makefile
##Author       : {_authorName}
##Module name  : Makefile
##Discribution : makefile script
##Date         : {_CurrTime}
##=========================================================

include ../../../../scr/verif/project_cfg.mk
#include ../cfg/verif/project_cfg.mk

'''.format(_authorName=GeneralDict['author'],_CurrTime=CurrTime)
    fileName = 'Makefile'
    genFile(path,fileName,fileContext)

def genAllSim(GeneralDict,AgentList,PathDict):
    genSim_makefile(GeneralDict,PathDict['sim'])

##========================================================================main=============================================================================================
def genIfList(IfList):
    tmpList = IfList.replace('\n','').replace('"','')[1:-1].split(',')
    if tmpList[-1]=='':
        tmpList.pop(-1)
    return tmpList

def DelTabInDict(Dict):
    for key,value in Dict.items():
        if '\t' in Dict[key]:
            Dict[key]=Dict[key].replace('\t',' ')

def DoIniParser():
    '''read ini file'''
    global IniFileName,CurrPath
    IniFilePath = CurrPath
    IniFile = os.path.abspath(os.path.join(IniFilePath,IniFileName))
    if os.path.exists(IniFile) is False:
        print(str(sys._getframe().f_lineno) + "@" + "ERROR::::{} not exists, please Check!".format(IniFile))
        sys.exit()
    Ini = ConfigParser()
    Ini.read(IniFile,encoding='utf-8')
    '''paser Ini'''
    GeneralDict = {}
    AgentList = []
    if 'ENV_GENERAL' not in Ini.sections():
        print(str(sys._getframe().f_lineno) + "@" + "ERROR::::there is no ENV_GENERAL section in ini file!".format(IniFile))
        sys.exit()
    for section in Ini.sections():
        if section=='ENV_GENERAL':
            for option in Ini.options(section):
                GeneralDict[option] = Ini.get(section,option)
                DelTabInDict(GeneralDict)
        else:
            tmpDict = {}
            tmpDict['agent_name'] = section
            for option in Ini.options(section):
                tmpDict[option] = Ini.get(section,option)
                DelTabInDict(tmpDict)
            AgentList.append(tmpDict)
    tmpEnvLevel = re.sub(" +","",GeneralDict['env_level'])
    envLevelList = ["st","it","bt","ut"]
    if tmpEnvLevel not in envLevelList:
        print(str(sys._getframe().f_lineno) + "@" + "ERROR::::env_level({}) not in {}, please check the xxx_env_cfg.ini".format(tmpEnvLevel,envLevelList))
        sys.exit()
    GeneralDict['env_level'] = tmpEnvLevel
    if "env_parameter" in GeneralDict.keys():
        try:
            envParameterDict = ast.literal_eval(GeneralDict["env_parameter"])
            GeneralDict["env_parameter"] = envParameterDict
            if len(GeneralDict['env_parameter'].keys())==0:
                del GeneralDict['env_parameter']
        except:
            print(str(sys._getframe().f_lineno) + "@" + "WARN::::env_parameter = {} is illegal, please check the cfg.ini!!!".format(GeneralDict['env_parameter']))
            del GeneralDict['env_parameter']
    for agent in AgentList:
        if agent["instance_by"]=='self':
            if 'agent_interface_list' not in agent.keys():
                print(str(sys._getframe().f_lineno) + "@" + "WARN::::ERROR::::there is no agent_interface_list for {}, please check the ini".format(agent['agent_name']))
                sys.exit()
            agent['agent_interface_list'] = genIfList(agent['agent_interface_list'])
        if "instance_num" not in agent.keys():
            agent['instance_type'] = "quantity"
            agent['instance_num'] = 1
        else:
            def genInstanceNumList(string):
                instanceNum = string.replace(" ","")
                if instanceNum[0]=="[" and instanceNum[-1]=="]":
                    tmpList = instanceNum[1:-1].split(",")
                    instanceList = []
                    for tmp in tmpList:
                        instanceList.append(tmp.replace("'",'"'))
                    isList = True
                else:
                    instanceList = []
                    isList = False
                return isList,instanceList
            isList,instanceNumList = genInstanceNumList(agent['instance_num'])
            if isList==True:
                agent['instance_type'] = "string"
                agent['instance_num'] = len(instanceNumList)
                agent['instance_list'] =  instanceNumList
            else:
                try:
                    if int(agent['instance_num']) <=0 :
                        print(str(sys._getframe().f_lineno) + "@" + "WARN::::the instance_num={} is illgel, used the default value 1".format(agent['instance_num']))
                        agent['instance_type'] = "quantity"
                        agent['instance_num'] = 1
                    else:
                        agent['instance_type'] = "quantity"
                        agent['instance_num'] = int(agent['instance_num'])
                except:
                        print(str(sys._getframe().f_lineno) + "@" + "WARN::::the instance_num={} is illgel, used the default value 1".format(agent['instance_num']))
                        agent['instance_type'] = "quantity"
                        agent['instance_num'] = 1
        if "parameter" in agent.keys():
            try:
                agentParameterDict = ast.literal_eval(agent["parameter"])
                agent["parameter"] = agentParameterDict
                if len(agent['parameter'].keys())==0:
                    del agent['parameter']
            except:
                print(str(sys._getframe().f_lineno) + "@" + "WARN::::agent({}) parameter = {} is illegal, please check the cfg.ini!!!".format(agent['agent_name'],agent['parameter']))
                del agent['parameter']
    for agent in AgentList:
        tmpAgent = agent
        hadFoundAgent = False
        if agent["instance_by"]!='self':
            for tmp in AgentList:
                if tmp["agent_name"]==agent["instance_by"]:
                    tmpAgent = tmp
                    hadFoundAgent = True
                    break
            if hadFoundAgent==True:
                agent['agent_interface_list'] = tmpAgent['agent_interface_list']
                if 'filelist_path' in agent.keys():
                    del agent['filelist_path']
            else:
                if 'agent_interface_list' not in agent.keys():
                    print(str(sys._getframe().f_lineno) + "@" + "ERROR::::there is no agent({}) or agent_interface_list for {}, please check the ini".format(agent['instance_by'],agent['agent_name']))
                    sys.exit()
                if 'filelist_path' not in agent.keys():
                    defauleFileListPath = "../../../common/agent/{_instanceBy}/{_instanceBy}.f".format(_instanceBy=agent['instance_by'])
                    print(str(sys._getframe().f_lineno) + "@" + "WARN::::there is no filelist_path for agent({}<-->{}), the filelist_path used the default path({})".format(agent['instance_by'],agent['agent_name'],defauleFileListPath))
                    agent['filelist_path'] = defauleFileListPath
                agent['agent_interface_list'] = genIfList(agent['agent_interface_list'])
        if agent['instance_num']==1:
            if 'dut_interface_list' not in agent.keys():
                if 'dut_interface_list0' not in agent.keys():
                    print(str(sys._getframe().f_lineno) + "@" + 'WARN:::this is no "dut_interface_list" or "dut_interface_list0" in {}, use the "agent_interface_list" as "dut_interface_list"'.format(agent['agent_name']))
                    agent['dut_interface_list0'] = agent['agent_interface_list']
                else:
                    print(str(sys._getframe().f_lineno) + "@" + 'WARN:::this is no "dut_interface_list" in {}, use the "dut_interface_list0" as "dut_interface_list"'.format(agent['agent_name']))
                    agent['dut_interface_list0'] = genIfList(agent['dut_interface_list0'])
            else:
                agent['dut_interface_list0'] = genIfList(agent['dut_interface_list'])
        else:
            for i in range(agent['instance_num']):
                if 'dut_interface_list{}'.format(i) not in agent.keys():
                    if 'dut_interface_list' in agent.keys():
                        print(str(sys._getframe().f_lineno) + "@" + 'WARN:::this is no "dut_interface_list{_i}" in {_agentName}, use the "dut_interface_list" as "dut_interface_list{_i}"'.format(_agentName=agent['agent_name'],_i=i))
                        agent['dut_interface_list{}'.format(i)] = genIfList(agent['dut_interface_list'])
                    else:
                        print(str(sys._getframe().f_lineno) + "@" + 'WARN:::this is neighter "dut_interface_list{_i}" nor "dut_interface_list" in {_agentName}, use the "agent_interface_list" as "dut_interface_list{_i}"'.format(_agentName=agent['agent_name'],_i=i))
                        agent['dut_interface_list{}'.format(i)] = agent['agent_interface_list']
                else:
                    agent['dut_interface_list{}'.format(i)] = genIfList(agent['dut_interface_list{}'.format(i)])
    return GeneralDict, AgentList

def GenDir(GeneralDict,AgentList):
    PathDict = {}
    PrjPath = GeneralDict['prj_path']
    PathDict['rtl'] = os.path.abspath(os.path.join(PrjPath,'rtl'))
    PathDict['lib'] = os.path.abspath(os.path.join(PrjPath,'lib'))
    PathDict['scr'] = os.path.abspath(os.path.join(PrjPath,'scr'))
    PathDict['scr_verif'] = os.path.abspath(os.path.join(PathDict['scr'],'verif'))
    PathDict['scr_common'] = os.path.abspath(os.path.join(PathDict['scr'],'common'))

    PathDict['ver'] = os.path.abspath(os.path.join(PrjPath,'ver'))
    PathDict['ver_common'] = os.path.abspath(os.path.join(PathDict['ver'],'common'))
    PathDict['ver_common_agent'] = os.path.abspath(os.path.join(PathDict['ver_common'],'agent'))
    PathDict['cmodel'] = os.path.abspath(os.path.join(PathDict['ver'],'cmodel'))
    PathDict['formal'] = os.path.abspath(os.path.join(PathDict['ver'],'formal'))
    PathDict['fw'] = os.path.abspath(os.path.join(PathDict['ver'],'fw'))
    PathDict['st'] = os.path.abspath(os.path.join(PathDict['ver'],'st'))
    PathDict['it'] = os.path.abspath(os.path.join(PathDict['ver'],'it'))
    PathDict['bt'] = os.path.abspath(os.path.join(PathDict['ver'],'bt'))
    PathDict['ut'] = os.path.abspath(os.path.join(PathDict['ver'],'ut'))

    PathDict['env_top'] = os.path.abspath(os.path.join(PathDict[GeneralDict['env_level']],GeneralDict['env_name']))
    PathDict['common'] = os.path.abspath(os.path.join(PathDict['env_top'],'common'))
    PathDict['env_common'] = os.path.abspath(os.path.join(PathDict['common'],'{_envName}_common'.format(_envName=GeneralDict['env_name'])))
    PathDict['env_common_src'] = os.path.abspath(os.path.join(PathDict['env_common'],'src'))
    PathDict['tb'] = os.path.abspath(os.path.join(PathDict['env_top'],'tb'))
    PathDict['assertion'] = os.path.abspath(os.path.join(PathDict['tb'],'assertion'))
    PathDict['sim'] = os.path.abspath(os.path.join(PathDict['env_top'],'sim'))
    PathDict['env'] = os.path.abspath(os.path.join(PathDict['env_top'],'env'))
    PathDict['env_src'] = os.path.abspath(os.path.join(PathDict['env'],'src'))
    PathDict['cfg'] = os.path.abspath(os.path.join(PathDict['env_top'],'cfg'))
    PathDict['cfg_vcs'] = os.path.abspath(os.path.join(PathDict['cfg'],'vcs_mk'))
    PathDict['cfg_xrun'] = os.path.abspath(os.path.join(PathDict['cfg'],'xrun_mk'))
    PathDict['cfg_verif'] = os.path.abspath(os.path.join(PathDict['cfg'],'verif'))
    PathDict['sva'] = os.path.abspath(os.path.join(PathDict['env_top'],'sva'))
    PathDict['tc'] = os.path.abspath(os.path.join(PathDict['env_top'],'tc'))
    PathDict['tc_src'] = os.path.abspath(os.path.join(PathDict['tc'],'src'))
    PathDict['agent'] = os.path.abspath(os.path.join(PathDict['env_top'],'agent'))
    PathDict['regress'] = os.path.abspath(os.path.join(PathDict['env_top'],'regress'))
    for agent in AgentList:
        if agent['instance_by']=='self':
            PathDict[agent['agent_name']] = os.path.abspath(os.path.join(PathDict['agent'],'{_agentName}_agent'.format(_agentName=agent['agent_name'])))
            PathDict[agent['agent_name']+'_src'] = os.path.abspath(os.path.join(PathDict[agent['agent_name']],'src'))
    while True:
        mkdirPath = True
        for path in PathDict.values():
            try:
                if os.path.exists(path) is False:
                    os.makedirs(path)
            except:
                mkdirPath = False
        if mkdirPath==True:
            break
    return PathDict

def genGeneralComment():
    comment = """;====================================================================================ENV_GENERAL===================================================================================================================================
;这一section设置环境通用选项,需要设定选项包括
;prj_path:指定当前工程路径(ver存放路径)
;author:环境作者
;env_name:环境名称
;env_level:指定环境等级,只能选择st/it/bt/ut，选择其他时脚本报错并退出
;rtl_top_name:当前环境验证的dut对应的module名称
;u_rtl_top_name:当前环境验证的dut对应的instance名称
;rtl_list:当前环境验证的dut对应的filelist
;env_parameter:指定当前环境是否带有parameter，为参数化环境，格式一定是
;----e.g.
;----env_parameter = {"ENV_AA":1,"ENV_BC":2}
;----在不指定env_parameter或者指定env_parameter = {}时，认为对应环境为不带参数agent
;================================================================================================================================================================================================================================="""
    return comment+"\n"

def genAgentComment():
    comment = """;=================================================================================================================================================================================================================================
;下面声明所有接口,每个接口一个section,section名称为接口的agent名称
;每个section包括以下option
;agent_mode:当前接口的例化模式,可选[master,only_monitor]
;----当接口设置为master时,sequencer和driver,monitor均打开
;----当接口设置为only_monitor是,sequencer和driver均关闭,只打开monitor
;instance_by:当前接口在环境中是由自身agent例化还是复用其他agent进行例化,可选[self,???]
;----输入选项为self时,脚本产生接口自身agent并例化到环境中
;----输入选项为其他agent名称时,则脚本不产生agent,只在环境中调用对应agent进行例化,这时候要求这两个agent的interface_list必须一致
;instance_num:指定当前agent在ENV中一共例化多少份,例化一份时此信息可以省略或指定为1,配置信息必须为大于等于1的正整数或者为对应例化列表
;
;agent_interface_list:列出接口的所有信号名称,格式为["input/output   bit  [xx:0]  $signal_name","..."]
;dut_interface_list:列出接口的所有信号对应的DUT接口信号
;----无论是agent_还是dut_, interface_list信号方向描述与DUT module接口list的方向一致
;----要求dut_interface_list(x)和agent_interface_list的信号位置一定是一一对应的，否则脚本自动连线会生成错误环境连线
;----要求多bit接口位宽的lsb一定从0开始
;-------对于 instance_by=self模式，agent_interface_list一定是必须指定的，否则脚本解析报错并退出
;-------对于 instance_by!=self模式，
;-----------对于VIP(脚本在ini中没有找到对应的instance_by agent)需要指定agent_interface_list,
;------------对于非VIP(脚本在ini中没有找到对应的instance_by agent)，agent_interface_list指定是无效的
;-------对于dut_interface_list在 instance_num大于1或为列表时，每一个对应list后缀必须加上对应的序号数字
;-------dut_instance_list(x)可以不止定，此时脚本会报告对应warning，需要后续手动修改环境中dut的例化及对应连线保证环境正确
;
;filelist_path:指定当前agent的路径，只针对instance_by!=self,并且在ini中找不到对应的instance_by agent的agent此配置有效
;----这时候脚本认为当前agent为例化VIP对应agent，不需要脚本自己生成
;-------因此需要对当前agent指定对应的filelist_path，agent_interface_list，及parameter，否则脚本生成环境可能会出错
;-------如果不指定filelist_path，同时脚本在ini中没有找到对应的instance_by agent时，会自动将默认filelist设置为../../../common/agent/{_instanceBy}/{_instanceBy}.f并报告相关warning
;-------另外，对于非VIP(脚本在ini中没有找到对应的instance_by agent),此配置无效
;
;parameter:指定当前agent是否带有parameter，为参数化agent，格式一定是
;----e.g.
;--------parameter = {"DW":64,"AW":32}
;----在不指定parameter或者指定parameter = {}时，认为对应agent为不带参数agent
;----PS: parameter 只有在instance_by=self或VIP(instance_by!=self并且ini中找不到对应的instance_by agent)才有效，同时其他 instance_by=这一个agent 的agent在例化一定时带同样parameter参数的
;----另外，在自动dut连线过程中，会将带paramter参数化的信号位宽声明的PARAMS改为${agent_name}_agent_dec::PARAMS,这里要求parameter和信号名称一定要遵循编码规范，一个大写一个小写，否则可能会改写错误
;channel_id_s:指定当前agent对应的channel_id，如果agent在env中例化不止一份，则指定起始ID，接下来对应的实例化agent脚本会自动加1处理
;----要求给定值一定是非负整数
;----如果没有给定channel_id_s，则脚本默认为0或上一个agent对应id加1处理
;scb_port_sel:指定当前agent在实例化之后，连接scoreboard的预期(exp)侧还是实际(act)侧，配置值只能是 exp或act，配置其他值无效，认为是exp
;----如果不给定scb_port_sel，则脚本默认为exp
;================================================================================================================================================================================================================================="""
    return comment+"\n"

def genEnvConfigIni(generalDict,allAgentDict):
    envConfig = ConfigParser()
    envConfig['ENV_GENERAL'] = generalDict
    agentConfig = ConfigParser()
    for agentName in allAgentDict.keys():
        agentConfig[agentName] = allAgentDict[agentName]
    with open("env_cfg.ini",'w',encoding='utf-8') as envConfigIniFile:
        envConfigIniFile.write(genGeneralComment())
        envConfig.write(envConfigIniFile)
        envConfigIniFile.write(genAgentComment())
        agentConfig.write(envConfigIniFile)

def scrollbarUpdate():
    global mainFrame
    global mainCanvas
    global scrollbarX
    global scrollbarY
    # 更新Frame大小，不然没有滚动效果
    mainFrame.update()
    # 将滚动按钮绑定只Canvas上
    mainCanvas.configure(xscrollcommand=scrollbarX.set, scrollregion=mainCanvas.bbox("all"))
    scrollbarX.config(command=mainCanvas.xview)
    mainCanvas.configure(yscrollcommand=scrollbarY.set, scrollregion=mainCanvas.bbox("all"))
    scrollbarY.config(command=mainCanvas.yview)

def addAgentDutIFList(myAgentIdx,myRow,myCol):
    global mainFrame
    global agentLabelList
    global currPosRow
    global currPosCol
    global getValueList
    global agentComponentList
    addListRow = myRow+1
    agentDutIfLIstIdx = len(getValueList[myAgentIdx+1]) - len(agentLabelList)
    addListCol = myCol + agentDutIfLIstIdx*2 + 1
    itemLabelName = Label(mainFrame, text="dut_interface_list{}".format(agentDutIfLIstIdx+1))
    itemLabelName.grid(row=addListRow,column=addListCol,rowspan=6,sticky=W)
    agentComponentList[myAgentIdx].append(itemLabelName)
    addListCol += 1
    itemText = Text(mainFrame,height=10,width=20)
    itemText.grid(row=addListRow,column=addListCol,rowspan=6)
    agentComponentList[myAgentIdx].append(itemText)
    getValue = itemText
    getValueList[myAgentIdx+1].append(getValue)
    scrollbarUpdate()

def destroyAgent(myAgentIdx):
    print(myAgentIdx)
    global getValueList
    global agentComponentList
    getValueList[myAgentIdx+1] = []
    for component in agentComponentList[myAgentIdx]:
        component.destroy()

def addAgent():
    global mainFrame
    global agentLabelList
    global currPosRow
    global currPosCol
    global getValueList
    global addAgentIdx
    global agentComponentList
    agentValueList = []
    currPosRow += 1
    currPosCol = 1
    myComponentList = []
    agentLabelName = Label(mainFrame, text="agent[{}]".format(addAgentIdx))
    agentLabelName.grid(row=currPosRow,column=currPosCol)
    myComponentList.append(agentLabelName)
    for item in agentLabelList:
        if item in ["agent_interface_list","dut_interface_list"]:
            currPosCol += 1
            itemLabelName = Label(mainFrame, text=item)
            itemLabelName.grid(row=currPosRow-5,column=currPosCol,rowspan=6,sticky=W)
            myComponentList.append(itemLabelName)
        else:
            currPosRow += 1
            currPosCol = 1
            itemLabelName = Label(mainFrame, text=item)
            itemLabelName.grid(row=currPosRow,column=currPosCol,sticky=W)
            myComponentList.append(itemLabelName)

        currPosCol += 1
        getValue = StringVar()
        if item=="agent_mode":
            boxList = ("master","only_monitor")
            itemCombobox = ttk.Combobox(mainFrame,textvariable=getValue,state='readonly',values=boxList)
            itemCombobox.grid(row=currPosRow,column=currPosCol)
            myComponentList.append(itemCombobox)
        elif item=="instance_by":
            boxList = ("self")
            itemCombobox = ttk.Combobox(mainFrame,textvariable=getValue,validate='focusout',values=boxList)
            itemCombobox.grid(row=currPosRow,column=currPosCol)
            itemCombobox.bind('<<ComboboxSelected>>')
            myComponentList.append(itemCombobox)
        elif item in ["agent_interface_list","dut_interface_list"]:
            itemText = Text(mainFrame,height=10,width=20)
            itemText.grid(row=currPosRow-5,column=currPosCol,rowspan=6)
            myComponentList.append(itemText)
            getValue = itemText
        elif item=="scb_port_sel":
            boxList = ("exp","act")
            itemCombobox = ttk.Combobox(mainFrame,textvariable=getValue,state='readonly',values=boxList)
            itemCombobox.grid(row=currPosRow,column=currPosCol)
            myComponentList.append(itemCombobox)
        else:
            itemEntry = Entry(mainFrame,textvariable=getValue)
            itemEntry.grid(row=currPosRow,column=currPosCol)
            myComponentList.append(itemEntry)
        agentValueList.append(getValue)
    getValueList.append(agentValueList)
    addButtonAgentIdx,addButtonRow,addButtonCol = addAgentIdx,currPosRow-6,currPosCol
    agentButton = Button(mainFrame, text="add DUT IF list", command=lambda:addAgentDutIFList(addButtonAgentIdx,addButtonRow,addButtonCol))
    agentButton.grid(row=addButtonRow,column=addButtonCol)
    myComponentList.append(agentButton)
    destroyButton = Button(mainFrame, text="delete agent[{}]".format(addButtonAgentIdx), command=lambda:destroyAgent(addButtonAgentIdx))
    destroyButton.grid(row=addButtonRow,column=addButtonCol-3)
    myComponentList.append(destroyButton)

    agentComponentList.append(myComponentList)
    addAgentIdx += 1
    scrollbarUpdate()

def reWriteIfListContext(context):
    tmpContext = re.sub("\n+","\n",re.sub(" \n","\n",re.sub(" +"," ",context)))
    if tmpContext=="\n":
        newContext = ""
    else:
        interfaceList = re.sub(" +"," ",tmpContext).split("\n")
        newContext = "[\n" + " "*4
        for interface in interfaceList:
            if interface!="":
                tmpInterface = interface.replace(";","").replace(",","")
                tmpInterface = tmpInterface.replace(" bit "," ")
                tmpInterface = tmpInterface.replace(" wire "," ")
                tmpInterface = tmpInterface.replace(" reg "," ")
                tmpInterface = tmpInterface.replace("input ","input bit ").replace("output ","output bit ").replace("inout ","inout bit ")
                newContext += '"' + tmpInterface + '",\n' + " "*4
        newContext += "]"
    return newContext

def getAgentContext(agentIdx,agentValueList):
    global agentLabelList
    agentDict = {}
    agentName = ""
    getAgentResult = True
    for i in range(len(agentValueList)):
        if i<len(agentLabelList):
            label = agentLabelList[i]
            if label in ["agent_interface_list","dut_interface_list"]:
                context = agentValueList[i].get("1.0","end")
                context = reWriteIfListContext(context)
            else:
                context = agentValueList[i].get()
            agentDict[label] = context
            if label=="agent_name":
                if context=="":
                    messagebox.showinfo("Generate Failed",'the "{}" must be input for agent[{}]'.format(label,agentIdx))
                    getAgentResult = False
                    return getAgentResult, agentName, agentDict
                else:
                    del(agentDict[label])
                    agentName = context
            elif label=="agent_mode":
                if context=="":
                    messagebox.showinfo("Generate Failed",'the "{}" must be input for agent[{}]'.format(label,agentName))
                    getAgentResult = False
                    return getAgentResult, agentName, agentDict
            elif label=="instance_by":
                if context=="":
                    messagebox.showinfo("Generate Failed",'the "{}" must be selecte(self) or input for agent[{}]'.format(label,agentName))
                    getAgentResult = False
                    return getAgentResult, agentName, agentDict
            elif label=="instance_num":
                if context=="":
                    messagebox.showinfo("Generate Failed",'the "{}" for agent[{}] must be a integer more than 0 or a list'.format(label,agentName))
                    getAgentResult = False
                    return getAgentResult, agentName, agentDict
                else:
                    def genInstanceNumList(context):
                        instanceList = context.replace(" ","")
                        if instanceList[0]=="[" and instanceList[-1]=="]":
                            tmpList = instanceList[1:-1].replace("'","").replace('"',"").split(",")
                            isList = True
                        else:
                            tmpList = []
                            isList = False
                        return isList,tmpList
                    isList,instanceList = genInstanceNumList(context)
                    if isList==True:
                        agentDict[label] = instanceList
                    else:
                        try:
                            num = int(context)
                            if num==0:
                                messagebox.showinfo("Generate Failed",'the "{}" for agent[{}] must be a integer more than 0 or a list'.format(label,agentName))
                                getAgentResult = False
                                return getAgentResult, agentName, agentDict
                            else:
                                agentDict[label] = num
                        except:
                            messagebox.showinfo("Generate Failed",'the "{}" for agent[{}] must be a integer more than 0 or a list'.format(label,agentName))
                            getAgentResult = False
                            return getAgentResult, agentName, agentDict
            elif label=="filelist_path":
                if agentDict["instance_by"]=="self":
                    del(agentDict[label])
                elif context=="":
                    messagebox.showinfo("Generate Warning",'there is no "{}" for agent[{}] with instance_by!=self'.format(label,agentName))
                    del(agentDict[label])
            elif label=="parameter":
                if context=="":
                    del(agentDict[label])
                else:
                    try:
                        parDict = ast.literal_eval(context)
                        if len(parDict.keys())==0:
                            del(agentDict[label])
                        else:
                            agentDict[label] = parDict
                    except:
                        messagebox.showinfo("Generate Failed",'the "{}" must be (e.g) or {{}} or be empty\n>>>>e.g.{{"DW":64,"AW":32}} for agent[{}]'.format(label,agentName))
                        getAgentResult = False
                        return getAgentResult, agentName, agentDict
            elif label=="channel_id_s":
                if context=="":
                    del(agentDict[label])
                else:
                    try:
                        num = int(context)
                        agentDict[label] = num
                    except:
                        messagebox.showinfo("Generate Failed",'the "{}" for agent[{}] must be a integer more than or equal to 0 or keep empty'.format(label,agentName))
                        getAgentResult = False
                        return getAgentResult, agentName, agentDict
            elif label=="scb_port_sel":
                if context=="":
                    del(agentDict[label])
            elif label=="agent_interface_list":
                if agentDict["instance_by"]=="self" and context=="":
                    messagebox.showinfo("Generate Failed",'the "{}" must be input for agent[{}] with "instance_by"=="self"'.format(label,agentName))
                    getAgentResult = False
                    return getAgentResult, agentName, agentDict
                elif context=="":
                    del(agentDict[label])
            elif label=="dut_interface_list":
                if context=="":
                    del(agentDict[label])
                elif isinstance(agentDict['instance_num'],int):
                    if agentDict['instance_num']>1:
                        agentDict["dut_interface_list0"] = agentDict[label]
                        del(agentDict[label])
                elif isinstance(agentDict['instance_num'],list):
                    if len(agentDict['instance_num'])>1:
                        agentDict["dut_interface_list0"] = agentDict[label]
                        del(agentDict[label])
        else:
            label = "dut_interface_list{}".format(i-len(agentLabelList)+1)
            context = agentValueList[i].get("1.0","end")
            context = reWriteIfListContext(context)
            if context!="":
                agentDict[label] = context
    return getAgentResult, agentName, agentDict

def getEntryContext(getValueList,generalLableList):
    global userCfg
    generalDict = {}
    allAgentDict = {}
    mustInputList = ["prj_path", "env_name", "env_level", "rtl_top_name", "u_rtl_top_name", "rtl_list"]
    for i in range(len(generalLableList)):
        context = getValueList[0][i].get()
        label = generalLableList[i]
        if context=="" and label in mustInputList:
            messagebox.showinfo("Generate Failed",'the "{}" must be input'.format(generalLableList[i]))
            return
        elif context=="" and label=="author":
            generalDict[generalLableList[i]] = "Heterogeneous Computing Group"
        elif label=="env_parameter":
            if context!="":
                try:
                    parDict = ast.literal_eval(context)
                    if len(parDict.keys())!=0:
                        generalDict[generalLableList[i]] = parDict
                except:
                    messagebox.showinfo("Generate Failed",'the "env_parameter" must be (e.g) or {{}} or be empty\n>>>>e.g.{{"ENV_AA":1,"ENV_BC":2}}')
                    return
        else:
            generalDict[generalLableList[i]] = context
    for actualAgentIdx in range(len(getValueList[1:])):
        tmpValueList = getValueList[actualAgentIdx+1]
        if len(tmpValueList)==0:
            print("agent[{}] had be destroy".format(actualAgentIdx))
            continue
        getAgentResult,agentName,agentDict = getAgentContext(actualAgentIdx,tmpValueList)
        if getAgentResult==False:
            return
        allAgentDict[agentName] = agentDict
    #print(generalDict)
    #print(allAgentDict)
    genEnvConfigIni(generalDict,allAgentDict)
    #messagebox.showinfo("Generate Done","env_cfg.ini had generated")
    userCfg.quit()

def genGeneralEntry():
    global mainFrame
    global generalLableList
    global currPosRow
    global currPosCol
    global getValueList
    generalValueList = []
    currPosRow += 1
    currPosCol = 1
    for i in range(len(generalLableList)):
        item = generalLableList[i]
        label = "{} :".format(item).ljust(18," ")
        if item=="rtl_top_name":
            currPosRow += 1
            currPosCol = 1
            itemLabelName = Label(mainFrame, text=label).grid(row=currPosRow,column=currPosCol,sticky=W)
        else:
            if i!=0:
                currPosCol += 1
            itemLabelName = Label(mainFrame, text=label).grid(row=currPosRow,column=currPosCol,sticky=W)
        currPosCol += 1
        getValue = StringVar()
        if item=="env_level":
            boxList = ("st","it","bt","ut")
            itemCombobox = ttk.Combobox(mainFrame,textvariable=getValue,state='readonly',values=boxList).grid(row=currPosRow,column=currPosCol)
        else:
            itemEntry = Entry(mainFrame,textvariable=getValue).grid(row=currPosRow,column=currPosCol)
        generalValueList.append(getValue)
    getValueList.append(generalValueList)

def genEnvConfigIniMain():
    global userCfg
    global mainCanvas
    global mainFrame
    global scrollbarX
    global scrollbarY
    global currPosRow
    global currPosCol
    global generalLableList
    global agentLabelList
    global getValueList
    global addAgentIdx
    global agentComponentList

    userCfg = Tk()
    userCfg.title("generate a env_cfg.ini")
    userCfg.geometry("1200x800")

    # Canvas,Scrollbar放置在主窗口上
    mainCanvas = Canvas(userCfg)
    scrollbarX = Scrollbar(userCfg,orient=HORIZONTAL)
    scrollbarX.pack(side=BOTTOM,fill=X)
    scrollbarY = Scrollbar(userCfg,orient=VERTICAL)
    scrollbarY.pack(side=RIGHT,fill=Y)
    mainCanvas.pack(side=LEFT,fill=BOTH,expand=YES)
    # Frame作为容器放置组件
    mainFrame = Frame(mainCanvas)
    mainFrame.pack()
    # 将Frame添加至Canvas上
    mainCanvas.create_window((0,0),window=mainFrame,anchor=NW)

    generalLableList = ["prj_path", "author", "env_name", "env_level", "rtl_top_name", "u_rtl_top_name", "rtl_list", "env_parameter"]
    agentLabelList = ["agent_name","agent_mode","instance_by","instance_num","filelist_path","parameter","channel_id_s","scb_port_sel","agent_interface_list","dut_interface_list"]
    getValueList = []

    currPosRow = 1
    currPosCol = 1
    generateButton = Button(mainFrame, text="generate", command=lambda:getEntryContext(getValueList,generalLableList)).grid(row=currPosRow,column=currPosCol)

    genGeneralEntry()

    addAgentIdx = 0
    currPosRow += 1
    currPosCol = 1
    agentComponentList = []
    agentButton = Button(mainFrame, text="add Agent", command=lambda:addAgent()).grid(row=currPosRow,column=currPosCol)

    scrollbarUpdate()

    userCfg.mainloop()

if __name__=="__main__":
    print('============>Step1: begin to genarate env verification !')
    CurrTime = time.strftime("%Y-%m-%d",time.localtime())
    CurrPath = sys.path[0]
    try:
        IniFileName = sys.argv[1]
        print(IniFileName)
    except:
        genEnvConfigIniMain()
        IniFileName = "env_cfg.ini"
    if IniFileName=="gen_ini":
        genEnvConfigIniMain()
        print("gen env_cfg.ini done!")
        sys.exit()

    print('============>Step2: get infomation from {_CurrPath}/{_IniFileName} ! '.format(_CurrPath=CurrPath,_IniFileName=IniFileName))
    tmpGeneralDict,tmpAgentList = DoIniParser()

    prjInfo = tmpGeneralDict['prj_path'] + "/ver/" + tmpGeneralDict['env_level'] + "/" + tmpGeneralDict['env_name']
    print("============>Step3: ready to mkdir about {_prjInfo} !".format(_prjInfo=prjInfo))
    tmpPathDict = GenDir(tmpGeneralDict,tmpAgentList)
    doScrpitCopy(tmpPathDict)

    print("============>Step4: ready to gen {_envName}_common !".format(_envName=tmpGeneralDict['env_name']))
    genEnvCommon(tmpGeneralDict,tmpAgentList,tmpPathDict)

    print("============>Step5: ready to gen agent !")
    genAllAgent(tmpGeneralDict,tmpAgentList,tmpPathDict)

    print("============>Step6: ready to gen ENV !")
    genAllEnv(tmpGeneralDict,tmpAgentList,tmpPathDict)

    print("============>Step7: ready to gen tb !")
    genAllTb(tmpGeneralDict,tmpAgentList,tmpPathDict)

    print("============>Step8: ready to gen tc !")
    genAllTc(tmpGeneralDict,tmpAgentList,tmpPathDict)

    print("============>Step9: ready to gen cfg !")
    genAllCfg(tmpGeneralDict,tmpAgentList,tmpPathDict)

    print("============>Step10: ready to gen sim !")
    genAllSim(tmpGeneralDict,tmpAgentList,tmpPathDict)

    print("============>Step11: env verification genarated Done !")
