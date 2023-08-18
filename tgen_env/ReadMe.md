<div style="font-size:3em; text-align:center;"> 《gen_env.py》使用说明 </div>
《gen_env.py》是腾讯蓬莱实验室验证组开发的自动生成UVM验证环境的脚本工具

# 目录
- [脚本执行需要安装的python包](#脚本执行需要安装的python包)
- [执行命名及对应描述](#执行命令及对应描述)
- [ini配置文件说明](#ini配置文件说明)
- [gui窗口及对应说明](#gui窗口及对应说明)

# 脚本执行需要安装的python包
脚本使用python语言实现，默认使用python3工具，在运行脚本之前，需要预先安装的python包及对应的安装命令包括：  
## ConfigParser
> pip3 install ConfigParser  

## tkinter
> yum install python3-tk* -y  
> yum install tk-devel -y  

# 执行命令及对应描述
## 1 ./gen_env.py xxx.ini
执行当前命令，脚本读取<xxx.ini>文件，解析后根据ini配置生成对应验证环境
## 2 ./gen_env.py
执行当前命令，弹出gui对话框，填写对话框之后点击generate，生成对应的验证环境
## 3 ./gen_env.py gen_ini
执行当前命令，弹出gui对话框，填写对话框之后点击generate，生成一个env_cfg.ini用于后续验证环境生成

# ini配置文件说明
生成环境命令除了直接再gui窗口填写配置信息之外，还可以预先编写准备好一个ini文件，然后脚本读取改ini文件后生成对应的验证环境。  
ini文件包括一个环境配置的section(ENV_GENERAL)和多个AGENT对应的section(agent_name)
## ENV_GENERAL section
ENV_GENERAL为环境通用配置section，其section名称一定是ENV_GENERAL，如果脚本读取ini文件后查找不到这一section，则报告如下错误并退出，不生成任何验证环境:  
> (ERROR::::there is no ENV_GENERAL section in ini file!)  

此section一共包括8个option配置信息，分别为prj_path、author、env_name、env_level、rtl_top_name、u_rtl_top_name、rtl_list、env_parameter(可选)
- prj_path
指定当前环境所在工程路径，脚本认为再prj_path下面一共包括bes,lib,rtl,scr,ver,xml...文件路径，其中scr及ver为验证环境生成所需的文件夹路径。脚本会判断prj_path/ver,prj_path/scr路径是否存在，如果不存在则创建对应的文件夹用于存放生成的验证环境。  
其中scr为项目通用脚本存放路径，对于验证而言主要存放仿真时使用的makefile及环境变量设置的shell脚本，ver则为验证环境的真实存放路径，包括common、cmodel、formal、fw、st、it、bt、ut等文件路径，其中  
> common: 为整个项目所有验证环境公用的通用component存放位置，主要存放公用的接口agent或VIP组件  
> cmodel: 主要存放环境对应的cmodel dip代码及其编译出来的可执行so文件   
> formal: 主要存放各个模块的formal执行脚本  
> fw: 主要存放fireware对应的bin文件  
> st/it/bt/ut: 为各个模块的验证环境主要存放路径，根据环境的env_level存到对应路径下  
- author
指定当前生成验证环境的作者(负责人)
- env_name
指定生成验证环境的名称
- env_level
指定生成验证环境对应的等级，只能配置为 st/it/bt/ut 中的一个，配置其他则报告如下错误并退出，不生成任何验证环境:  
> ERROR::::env_level(At) not in ['st', 'it', 'bt', 'ut'], please check the xxx_env_cfg.ini  
- rtl_top_name
指定生成验证环境所要验证的DUT module名称  
- u_rtl_top_name
指定生成验证环境索要验证的DUT在环境中的例化名称
- rtl_list
指定生成验证环境所有验证的DUT对应filelist对应的路径
- env_parameter
如果生成验证环境为参数话环境，则可以通过env_parameter指定对应的parameter，否则，此option可以不填写  
env_parameter必须给定格式为 {"parameter名称"：parameter对应默认值}，如果不是这一格式，则报告如下提示信息并生成一个不带参数的验证环境：  
> WARN::::env_parameter = aaa is illegal, please check the cfg.ini!!!  

## AGENT section
除了ENV_GENERAL section之外，脚本将ini配置文件中其他每一个section都认为是生成验证环境中的一个AGENT配置信息，section名称即为agent名称。对于每一个AGENT section，一共包括7个optino配置信息，分别为agent_mode、instance_by、instance_num、agent_interface_list、dut_interface_list(dut_interface_list0|1|2....)、filelist_path、parameter
- agent_mode
指定当前agent对应的模式，只能配置为master或only_monitor，如果配置为其他，则脚本将其认为是only_monitor  
> master: 生成agent的sequencer/driver/monitor均打开  
> only_monitor: 生成agent的sequencer/driver关闭，monitor打开  
- instance_by
指定当前agent在生成环境中是由哪个agent例化  
> 如果agent由自身例化，则配置值为self,此时脚本生成对应agent组件并在env中调用例化  
> 如果agent为复用例化，则配置值为想要复用的agent(或VIP)名称，此时脚本不生成当前agent组件，只在env中调用例化此agent并连线  
- instance_num
指定当前agent在生成环境中例化个数，可以为指定大于0的数值，也可以是一个例化string的列表
> 如果指定为大于0的数值，则生成环境安照静态数组的方式生成对应组件数组的例化并连线，在指定值为1时，例化为单个instance，不为数组  
> 如果指定为一个string列表，例如['new','old','org']，则此时按照关联数组方式生成对应组件数组的例化并连线  
- agent_interface_list
指定当前agent的接口列表，接口方向与DUT module内方向一直，同时需要在接口方向后加上一个关键字(bit)供脚本查找  
> 如果instance_by为self，此option必须定义  
> 如果instance_by不为self，并且想要复用的agent不在ini配置中有描述(如VIP)，此option也必须定义  
> 如果instance_by不为self，并且想要复用的agent在ini配置中有描述，则此option无需定义，定义了脚本也不会使用  
- dut_interface_list(dut_interface_list0|1|2....)
指定当前agent与dut对应dut module上声明的dutlist，如果instance_num为1，则此时只有一个dut_interface_list(0),否则，由多少个instance_num,就需要多少份dut_interface_list0|1|2...，并用后缀0|1|2...描述分开，保证脚本能正确帮忙连线  
> 要求dut_interface_list与agent_interface_list信号描述位置必须一致  
- filelist_path
指定当前agent的位置，只有在agent为VIP调用时才需要指定，如果agent的instance_by为self或者不为self但是在ini中有描述，此option指定无效
- parameter
指定当前agent是否为可参数化的agent，parameter的指定规则同[ENV_GENERAL.env_parameter](##ENV_GENERAL-section)

# gui窗口及对应说明
gui窗口用于生成环境对应参数配置输入，具体如下图所示，包括环境配置和AGENT配置两部分
## 环境配置部分说明
TODO
## AGENT配置部分说明
TODO
