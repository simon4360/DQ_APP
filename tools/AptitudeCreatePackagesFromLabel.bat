set /P inputSolution="Which Solution do you want to extract from? "

set /P inputLabel="Which label do you want to extract? "

set /P outputDirectory="Where do you want to extract to (blank defaults to git) ? "

IF NOT DEFINED outputDirectory SET outputDirectory="C:\Users\s4an5p\Aptitude"

if not exist %outputDirectory% mkdir %outputDirectory% 

set Phost="srl000000014"
set Pport="3000"

cd C:\Users\s4an5p\AppData\Local\Microsoft\AppV\Client\Integration\25471482-26B0-4DCA-B416-7B83DC0A3991\Root\VFS\ProgramFilesX64\Aptitude Software\Aptitude 5.10 build 7.2\Client

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g71_tgt_g72

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g72_tgt_g71

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g74_tgt_crr

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_housekeeping

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_library

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_maintain_data

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_retro

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_ady

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_asl

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_ers

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_fa0

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g24

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g32

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g51

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g61

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g71

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g72

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g73

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g74

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g76

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g79

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g7c

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_g7m

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_mdm

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_pil

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_src_q0t

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_a38

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_ady

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_crr

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g24

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g32

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g51

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g72

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g73

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g74

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g76

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g77

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g79

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_g7c

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_pho

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_tgt_rvl

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g77_utils

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g7c_tgt_a38

Microgen.Aptitude.Studio.Console.exe -cmd createAptDeploymentPckgFromRepo -host %Phost% -port %Pport% -user admin -pass sreM1crogene -solution  %inputSolution% -label %inputLabel% -targetDir %outputDirectory% -project g7c_tgt_g24
    
