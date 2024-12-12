function [DMSO, ML141_75uM] = experimentData(roiWidthInMicrons)
    %% How data is stored in this file
    %I'm making use of object oriented coding in this script to assign all the
    %relevant data for each experiment to a labelled condition (DMSO or
    %ML141_75uM) and then data for each experiment can be accessed within
    %that using the dot notation as follows:
    
    % condition.Exp#.image{sliceNumber, zPositionNumber, roiNumber} <-- this is how the below images are stored
    % For example, if you want access image data for experiment 2 under DMSO conditions, you would write:
    % DMSO.exp2.image{3, 2, 1}
    % Where 3 is accessing the 3rd slice, 2 indicates the 2 z-depth image
    % within that slice, and 1 is accessing the first region of interest
    % (left hand side of the ventricle (1) versus right hand side (2)). 
    
    % For storing regions of interest, each column corresponds to a seperate roi, 
    % and each row define the x, y, width, and height of the roi:
    % [x1, y1, width1, height1]
    
    %% DMSO Experiment 1
    addpath('data\Exp1_2023_10_13\DMSO\')
    
    DMSO.Exp1.date     = datetime(2023, 10, 13);
    DMSO.Exp1.name     = 'DMSO Exp1';
    DMSO.Exp1.dx       = 1/2.35;                                                %um/pixel
    DMSO.Exp1.rotation = 140;                                       %Each index corresponds to slice number
    w = round(roiWidthInMicrons / DMSO.Exp1.dx);                                %Width of roi in pixels
             
    
    %Slice 2___________________________________________________________________
    DMSO.Exp1.image{1, 1}    = imread('DMSO Slice2 z10.png');                   %S2, Z1
    DMSO.Exp1.roi  {1, 1}    = [580; 310; w; 560];                              %Define roi
    
    DMSO.Exp1.image{1, 2}    = imread('DMSO Slice2 z15.png');                   %S2, Z2
    DMSO.Exp1.roi  {1, 2, 1} = [580; 310; w; 560];                              %Define roi
    
    rmpath('data\Exp1_2023_10_13\DMSO\')
    
    
    %% DMSO Experiment 2
    addpath('data\Exp2_2024_02_05\DMSO\')
    
    DMSO.Exp2.date     = datetime(2024, 2, 5);
    DMSO.Exp2.name     = 'DMSO Exp2';
    DMSO.Exp2.dx       = 1/3.3875;                                              %um/pixel
    DMSO.Exp2.rotation = [5; 0];                                             %Each index corresponds to slice number
    w = round(roiWidthInMicrons / DMSO.Exp2.dx);  
    
    DMSO.Exp2.image{1, 1}    = imread('DMSO Slice2 z15.png');                   %S2, Z2
    DMSO.Exp2.roi  {1, 1}    = [270; 220; w; 800];   
    
    
    DMSO.Exp2.image{1, 2}    = imread('DMSO Slice2 z25.png');                   %S2, Z3
    DMSO.Exp2.roi  {1, 2}    = [290; 260; w; 800];  
    
    %Slice 3___________________________________________________________________
    DMSO.Exp2.image{2, 1}    = imread('DMSO Slice4 z10.png');                   %S3, Z1
    DMSO.Exp2.roi  {2, 1}    = [840; 880; w; 800];  
    
    rmpath('data\Exp2_2024_02_05\DMSO\')
    
    
    %% DMSO Experiment 3
    addpath('data\Exp3_2024_03_04\DMSO\')
    
    DMSO.Exp3.date     = datetime(2024, 3, 4);
    DMSO.Exp3.name     = 'DMSO Exp3';
    DMSO.Exp3.dx       = 1/2.4089;                                              %um/pixel
    DMSO.Exp3.rotation = [0; 15; 0];                                             %Each index corresponds to slice number
    w = round(roiWidthInMicrons / DMSO.Exp3.dx);
    
    %Slice 1___________________________________________________________________
    DMSO.Exp3.image{1, 1}    = imread('DMSO slice1 z9.png');                    %S1, Z2
    DMSO.Exp3.roi  {1, 1, 1}    = [400; 480; w; 660]; 
    
    DMSO.Exp3.image{1, 2}    = imread('DMSO slice1 z14.png');                    %S1, Z1
    DMSO.Exp3.roi  {1, 2, 1}    = [390; 350; w; 700]; 
    
    
    %% DMSO Experiment 4
    addpath('data\Exp4_2024_04_10\DMSO')
    
    DMSO.Exp4.date     = datetime(2024, 4, 10);
    DMSO.Exp4.name     = 'DMSO Exp4';
    DMSO.Exp4.dx       = 1/2.168;                                              %um/pixel
    DMSO.Exp4.rotation = [0; 8; 0];       
    w = round(roiWidthInMicrons / DMSO.Exp4.dx); 
    
    
    %Slice 1___________________________________________________________________
    DMSO.Exp4.image{1, 1}    = imread('DMSO dish1 slice3 z5.png');                    %S1, Z1
    DMSO.Exp4.roi  {1, 1, 1}    = [300; 300; w; 600];  
    DMSO.Exp4.roi  {1, 1, 2}    = [230; 300; w; 600]; 
    
    DMSO.Exp4.image{1, 2}    = imread('DMSO dish1 slice3 z12.png');                    %S1, Z1
    DMSO.Exp4.roi  {1, 2, 1}    = [290; 300; w; 570];  
    DMSO.Exp4.roi  {1, 2, 2}    = [210; 300; w; 570]; 
    
    %Slice 2___________________________________________________________________
    DMSO.Exp4.image{2, 1}    = imread('DMSO dish1 slice4 z5.png');                    %S2, Z1
    DMSO.Exp4.roi  {2, 1, 1}    = [280; 340; w; 540];  
    DMSO.Exp4.roi  {2, 1, 2}    = [200; 340; w; 540]; 

    DMSO.Exp4.image{2, 2}    = imread('DMSO dish1 slice4 z12.png');                    %S2, Z1
    DMSO.Exp4.roi  {2, 2, 1}    = [290; 260; w; 520];  
    DMSO.Exp4.roi  {2, 2, 2}    = [200; 260; w; 520]; 
    % 
    %Slice 3___________________________________________________________________
    DMSO.Exp4.image{3, 1}    = imread('DMSO dish2 slice2 z12.png');                    %S3, Z1
    DMSO.Exp4.roi  {3, 1, 1}    = [300; 210; w; 700];  

    DMSO.Exp4.image{3, 2}    = imread('DMSO dish2 slice2 z19.png');                    %S3, Z1
    DMSO.Exp4.roi  {3, 2, 1}    = [210; 200; w; 650];
    DMSO.Exp4.roi  {3, 2, 2}    = [300; 200; w; 650];  
    
    rmpath('data\Exp4_2024_04_10\DMSO\')
    
    
    
    %% DMSO Experiment 5
    addpath('data\Exp5_2024_05_15\DMSO\')
    
    DMSO.Exp5.date     = datetime(2024, 5, 15);
    DMSO.Exp5.name     = 'DMSO Exp5';
    DMSO.Exp5.dx       = 1/2.4089;                                              %um/pixel
    DMSO.Exp5.rotation = [0, -5, -9, -14]; 
    % DMSO.Exp5.rotation = -14; 
    w = round(roiWidthInMicrons / DMSO.Exp5.dx);
    
    % Slice 1_______________________________________________________________0
    DMSO.Exp5.image{1, 1}    = imread('DMSO Slice1 z11.png');                    %S1, Z1
    DMSO.Exp5.roi  {1, 1, 1}    = [350; 560; w; 490]; 
    DMSO.Exp5.roi  {1, 1, 2}    = [440; 560; w; 490]; 
    
    %Slice 2_______________________________________________________________ -5
    DMSO.Exp5.image{2, 1}    = imread('DMSO Slice1 z18.png');                    %S1, Z1
    DMSO.Exp5.roi  {2, 1, 1}    = [280; 530; w; 500]; 
    DMSO.Exp5.roi  {2, 1, 2}    = [390; 530; w; 400]; 
    
    %Slice 2_______________________________________________________________ -9
    DMSO.Exp5.image{3, 1}    = imread('DMSO Slice3 z8.png');                    %S1, Z1
    DMSO.Exp5.roi  {3, 1, 1}    = [580; 610; w; 520]; 
    
    %Slice 2_______________________________________________________________-14
    DMSO.Exp5.image{4, 1}    = imread('DMSO Slice3 z21.png');                    %S1, Z1
    DMSO.Exp5.roi  {4, 1, 1}    = [520; 580; w; 390]; 
    DMSO.Exp5.roi  {4, 1, 2}    = [620; 620; w; 480]; 
    
    rmpath('data\Exp5_2024_05_15\DMSO\')
    
    
    
    %% DMSO Experiment 6
    addpath('data\Exp6_2024_06_19\DMSO\')
    
    DMSO.Exp6.date     = datetime(2024, 6, 19);
    DMSO.Exp6.name     = 'DMSO Exp6';
    DMSO.Exp6.dx       = 1/2.168;                                              %um/pixel
    % DMSO.Exp6.rotation = [5, 3, 8, -8, -13];    
    DMSO.Exp6.rotation = [5, 8, -8, -13];   
    % DMSO.Exp6.rotation = -5;    
    w = round(roiWidthInMicrons / DMSO.Exp6.dx);
    
    %Slice 1_______________________________________________________________ 5
    DMSO.Exp6.image{1, 1}    = imread('DMSO slice1.png');                      %S1, Z1
    DMSO.Exp6.roi  {1, 1, 1}    = [350; 210; w; 590]; 
    
    % %Slice 2_________________________________________________________________ 3
    % DMSO.Exp6.image{2, 1}    = imread('DMSO slice3.png');                      %S2, Z1
    % DMSO.Exp6.roi  {2, 1, 1}    = [530; 460; w; 660]; 
    
    %Slice 3_________________________________________________________________ 8
    DMSO.Exp6.image{2, 1}    = imread('DMSO slice10.png');                      %S3, Z1
    DMSO.Exp6.roi  {2, 1, 1}    = [310; 240; w; 480]; 
    
    %Slice 4______________________________________________________________ -8
    DMSO.Exp6.image{3, 1}    = imread('DMSO slice4 z3.png');                   %S4, Z1
    DMSO.Exp6.roi  {3, 1, 1}    = [430; 490; w; 560]; 
    
    DMSO.Exp6.image{3, 2}    = imread('DMSO slice4 z7.png');                   %S4, Z2
    DMSO.Exp6.roi  {3, 2, 1}    = [445; 500; w; 720]; 
    
    %Slice 5_____________________________________________________________ -13
    DMSO.Exp6.image{4, 1}    = imread('DMSO slice11.png');                     %S5, Z1
    DMSO.Exp6.roi  {4, 1, 1}    = [390; 580; w; 590]; 
    
    rmpath('data\Exp6_2024_06_19\DMSO\')
    
    
    
    %% DMSO Experiment 7
    addpath('data\Exp7_2024_06_20\DMSO\')
    
    DMSO.Exp7.date     = datetime(2024, 6, 20);
    DMSO.Exp7.name     = 'DMSO Exp7';
    DMSO.Exp7.dx       = 1/2.1678;                                              %um/pixel
    DMSO.Exp7.rotation = [-2, 5, -1, -5, 5, 0];   
    % DMSO.Exp7.rotation = -5;  
    w = round(roiWidthInMicrons / DMSO.Exp7.dx);
    
    %Slice 1________________________________________________________________-2
    DMSO.Exp7.image{1, 1}    = imread('DMSO slice2.png');                      %S1, Z1
    DMSO.Exp7.roi  {1, 1, 1} = [200; 280; w; 550]; 
    
    %Slice 2__________________________________________________________________5
    DMSO.Exp7.image{2, 1}    = imread('DMSO slice2.png');                      %S1, Z1
    DMSO.Exp7.roi  {2, 1, 1} = [300; 240; w; 360]; 
    % 
    %Slice 3_________________________________________________________________-1
    DMSO.Exp7.image{3, 1}    = imread('DMSO slice5.png');                      %S1, Z1
    DMSO.Exp7.roi  {3, 1, 1} = [290; 260; w; 550];
    
    % Slice 4_________________________________________________________________-5
    DMSO.Exp7.image{4, 1}    = imread('DMSO slice7.png');                      %S1, Z1
    DMSO.Exp7.roi  {4, 1, 1} = [230; 590; w; 500];
    
    %Slice 5_________________________________________________________________5
    DMSO.Exp7.image{5, 1}    = imread('DMSO slice4.png');                      %S1, Z1
    DMSO.Exp7.roi  {5, 1, 1} = [510; 510; w; 600]; 
    
    %Slice 6_________________________________________________________________0
    DMSO.Exp7.image{6, 1}    = imread('DMSO slice6.png');                      %S1, Z1
    DMSO.Exp7.roi  {6, 1, 1} = [230; 310; w; 420]; 
    
    rmpath('data\Exp7_2024_06_20\DMSO\')
    
    
    
    
    
    
    
    
    
    
    
    %% ML141 75uM Experiment 2
    addpath('data\Exp2_2024_02_05\ML141 75uM\')
    
    ML141_75uM.Exp2.date     = datetime(2024, 2, 5);
    ML141_75uM.Exp2.name     = 'ML141 75uM Exp2';
    ML141_75uM.Exp2.dx       = 1/3.3875;                                        %um/pixel
    ML141_75uM.Exp2.rotation = [0, -20];                                    %Each index corresponds to slice number
    w = round(roiWidthInMicrons / ML141_75uM.Exp2.dx); 
    
    ML141_75uM.Exp2.image{1, 1} = imread('ML141 75uM Slice2 z8.png');           %S2, Z1
    ML141_75uM.Exp2.roi  {1, 1} = [950; 720; w; 730];                           %Define roi
    
    ML141_75uM.Exp2.image{2, 1} = imread('ML141 75uM Slice3 z4.png');           %S2, Z1
    ML141_75uM.Exp2.roi  {2, 1} = [520; 590; w; 570];                           %Define roi
    
    rmpath('data\Exp2_2024_02_05\ML141 75uM\')
    
    
    
    %% ML141 75uM Experiment 3
    addpath('data\Exp3_2024_03_04\ML141 75uM\')
    
    ML141_75uM.Exp3.date     = datetime(2024, 3, 4);
    ML141_75uM.Exp3.name     = 'ML141 75uM Exp3';
    ML141_75uM.Exp3.dx       = 1/2.4089;                                        %um/pixel
    ML141_75uM.Exp3.rotation = [170, 180, -9];                                      %Each index corresponds to slice number
    w = round(roiWidthInMicrons / ML141_75uM.Exp3.dx);
    
    %Slice 1___________________________________________________________________
    ML141_75uM.Exp3.image{1, 1} = imread('ML141 75uM slice1 z17.png');          %S1, Z1
    ML141_75uM.Exp3.roi  {1, 1} = [200; 130; w; 650];                           %Define roi
    
    %Slice 2___________________________________________________________________
    ML141_75uM.Exp3.image{2, 1} = imread('ML141 75uM slice2 z10.png');          %S2, Z1
    ML141_75uM.Exp3.roi  {2, 1, 1} = [320; 200; w; 430]; 
    
    ML141_75uM.Exp3.image{2, 2} = imread('ML141 75uM slice2 z15.png');       %S2, Z2
    ML141_75uM.Exp3.roi  {2, 2, 1} = [320; 200; w; 430];
    
    %Slice 3___________________________________________________________________
    ML141_75uM.Exp3.image{3, 1} = imread('ML141 75uM slice3 z13.png');       %S3, Z1
    ML141_75uM.Exp3.roi  {3, 1, 1} = [390; 700; w; 510];
    ML141_75uM.Exp3.roi  {3, 1, 2} = [460; 750; w; 430];
    
    ML141_75uM.Exp3.image{3, 2} = imread('ML141 75uM slice3 z18.png');       %S3, Z2
    ML141_75uM.Exp3.roi  {3, 2, 1} = [350; 800; w; 430];
    
    ML141_75uM.Exp3.image{3, 3} = imread('ML141 75uM slice3 z23.png');       %S3, Z3
    ML141_75uM.Exp3.roi  {3, 3, 1} = [330; 800; w; 410];
    ML141_75uM.Exp3.roi  {3, 3, 2} = [410; 800; w; 410];
    
    ML141_75uM.Exp3.image{3, 4} = imread('ML141 75uM slice3 z28.png');       %S3, Z3
    ML141_75uM.Exp3.roi  {3, 4, 1} = [300; 800; w; 460];
    ML141_75uM.Exp3.roi  {3, 4, 2} = [380; 840; w; 450];
    
    rmpath('data\Exp3_2024_03_04\ML141 75uM\')
    
    
    %% ML141 75uM Experiment 4
    addpath('data\Exp4_2024_04_10\ML141 75uM\')
    
    ML141_75uM.Exp4.date     = datetime(2024, 4, 10);
    ML141_75uM.Exp4.name     = 'ML141 75uM Exp4';
    ML141_75uM.Exp4.dx       = 1/2.1680;                                        %um/pixel
    ML141_75uM.Exp4.rotation = [0, -5, 5, 2, 3, 0];                                      %Each index corresponds to slice number
    w = round(roiWidthInMicrons / ML141_75uM.Exp4.dx);
    
    
    % % Slice 1___________________________________________________________________
    ML141_75uM.Exp4.image{1, 1} = imread('d3s1z26.png');          %S1, Z1
    ML141_75uM.Exp4.roi  {1, 1, 1} = [200; 350; w; 400];                           %Define roi
    ML141_75uM.Exp4.roi  {1, 1, 2} = [290; 350; w; 400];

    ML141_75uM.Exp4.image{1, 2} = imread('d3s1z33.png');          %S1, Z2
    ML141_75uM.Exp4.roi  {1, 2, 1} = [190; 350; w; 400]; 
    ML141_75uM.Exp4.roi  {1, 2, 2} = [280; 350; w; 400]; 
    % 
    %Slice 2___________________________________________________________________
    ML141_75uM.Exp4.image{2, 1} = imread('d3s2z20.png');          %S2, Z1
    ML141_75uM.Exp4.roi  {2, 1, 1} = [200; 260; w; 440];                           %Define roi
    ML141_75uM.Exp4.roi  {2, 1, 2} = [290; 260; w; 440];
    
    ML141_75uM.Exp4.image{2, 2} = imread('d3s2z27.png');          %S2, Z2
    ML141_75uM.Exp4.roi  {2, 2, 1} = [200; 280; w; 400];                           %Define roi
    ML141_75uM.Exp4.roi  {2, 2, 2} = [260; 280; w; 400];
     
    %Slice 3___________________________________________________________________
    ML141_75uM.Exp4.image{3, 1} = imread('d3s3z1.png');          %S3, Z1
    ML141_75uM.Exp4.roi  {3, 1, 1} = [200; 380; w; 490];                           %Define roi
    ML141_75uM.Exp4.roi  {3, 1, 2} = [270; 380; w; 530];

    ML141_75uM.Exp4.image{3, 2} = imread('d3s3z8.png');          %S3, Z2
    ML141_75uM.Exp4.roi  {3, 2, 1} = [190; 380; w; 480];                           %Define roi
    ML141_75uM.Exp4.roi  {3, 2, 2} = [260; 380; w; 480];
    
    %Slice 4___________________________________________________________________
    ML141_75uM.Exp4.image{4, 1} = imread('d4s1z25.png');          %S4, Z1
    ML141_75uM.Exp4.roi  {4, 1, 1} = [230; 250; w; 500];                           %Define roi
    ML141_75uM.Exp4.roi  {4, 1, 2} = [310; 250; w; 500];

    %Slice 5___________________________________________________________________
    ML141_75uM.Exp4.image{5, 1} = imread('d4s2z21.png');          %S5, Z1
    ML141_75uM.Exp4.roi  {5, 1, 1} = [180; 370; w; 400];                           %Define roi
    ML141_75uM.Exp4.roi  {5, 1, 2} = [300; 370; w; 400];

    %Slice 6___________________________________________________________________
    ML141_75uM.Exp4.image{6, 1} = imread('d4s3z9.png');          %S3, Z1
    ML141_75uM.Exp4.roi  {6, 1, 1} = [300; 330; w; 450];

    ML141_75uM.Exp4.image{6, 2} = imread('d4s3z16.png');          %S3, Z2
    ML141_75uM.Exp4.roi  {6, 2, 1} = [180; 300; w; 490];                           %Define roi
    ML141_75uM.Exp4.roi  {6, 2, 2} = [280; 380; w; 460];
    
    
    rmpath('data\Exp4_2024_04_10\ML141 75uM\')
    
    
    
    %% ML141 75uM Experiment 5
    addpath('data\Exp5_2024_05_15\ML141 75uM\')
    
    ML141_75uM.Exp5.date     = datetime(2024, 5, 15);
    ML141_75uM.Exp5.name     = 'ML141 75uM Exp5';
    ML141_75uM.Exp5.dx       = 1/2.4089;                                        %um/pixel
    ML141_75uM.Exp5.rotation = [0, -3];                                      %Each index corresponds to slice number
    w = round(roiWidthInMicrons / ML141_75uM.Exp5.dx);
    
    
    %Slice 2___________________________________________________________________
    
    ML141_75uM.Exp5.image{1, 1} = imread('ML141 75uM Slice2 z19.png');          %S2, Z2
    ML141_75uM.Exp5.roi  {1, 1, 1} = [320; 370; w; 430];
    ML141_75uM.Exp5.roi  {1, 1, 2} = [430; 370; w; 400];
    
    ML141_75uM.Exp5.image{1, 2} = imread('ML141 75uM Slice2 z26.png');          %S2, Z3
    ML141_75uM.Exp5.roi  {1, 2, 1} = [390; 360; w; 380];
    
    rmpath('data\Exp5_2024_05_15\ML141 75uM\')
    
    
    
    %% ML141 75uM Experiment 6
    addpath('data\Exp6_2024_06_19\ML141 75uM\')
    
    ML141_75uM.Exp6.date     = datetime(2024, 6, 19);
    ML141_75uM.Exp6.name     = 'ML141 75uM Exp6';
    ML141_75uM.Exp6.dx       = 1/2.1678;                                        %um/pixel
    ML141_75uM.Exp6.rotation = [-25, 15, 0, 0, 13]; 
    % ML141_75uM.Exp6.rotation = -0;  %Each index corresponds to slice number
    w = round(roiWidthInMicrons / ML141_75uM.Exp6.dx);
    
    %Slice 1_______________________________________________________________ -25
    ML141_75uM.Exp6.image{1, 1} = imread('ML141 75uM slice2 z6.png');          %S1, Z1
    ML141_75uM.Exp6.roi  {1, 1, 1} = [370; 340; w; 610];
    
    %Slice 2______________________________________________________________ 15
    ML141_75uM.Exp6.image{2, 1} = imread('ML141 75uM slice2 z10.png');          %S1, Z1
    ML141_75uM.Exp6.roi  {2, 1, 1} = [610; 590; w; 410];
    
    %Slice 3_______________________________________________________________ 0
    ML141_75uM.Exp6.image{3, 1} = imread('ML141 75uM slice6 z4.png');          %S1, Z1
    ML141_75uM.Exp6.roi  {3, 1, 1} = [220; 190; w; 500];
    
    % ML141_75uM.Exp6.image{3, 2} = imread('ML141 75uM slice6 z12.png');          %S1, Z1
    % ML141_75uM.Exp6.roi  {3, 2, 1} = [220; 190; w; 500];
    
    %Slice 4________________________________________________________________ 0
    ML141_75uM.Exp6.image{4, 1} = imread('ML141 75uM slice8.png');          %S1, Z1
    ML141_75uM.Exp6.roi  {4, 1, 1} = [520; 340; w; 610];
    
    %Slice 5________________________________________________________________ 13
    ML141_75uM.Exp6.image{5, 1} = imread('ML141 75uM slice10.png');          %S1, Z1
    ML141_75uM.Exp6.roi  {5, 1, 1} = [300; 370; w; 430];
    
    rmpath('data\Exp6_2024_06_19\ML141 75uM\')
    
    
    %% ML141 75uM Experiment 7
    addpath('data\Exp7_2024_06_20\ML141 75uM\')
    
    ML141_75uM.Exp7.date     = datetime(2024, 6, 20);
    ML141_75uM.Exp7.name     = 'ML141 75uM Exp7';
    ML141_75uM.Exp7.dx       = 1/2.1678;                                        %um/pixel
    ML141_75uM.Exp7.rotation = [-5, 0, 0];                                      %Each index corresponds to slice number
    w = round(roiWidthInMicrons / ML141_75uM.Exp7.dx);
    
    
    %Slice 1________________________________________________________________-5
    ML141_75uM.Exp7.image{1, 1} = imread('ML141 75uM slice4.png');          %S1, Z1
    ML141_75uM.Exp7.roi  {1, 1, 1} = [200; 250; w; 310];
    ML141_75uM.Exp7.roi  {1, 1, 2} = [300; 300; w; 290];
    
    %Slice 2______________________________________________________________0
    ML141_75uM.Exp7.image{2, 1} = imread('ML141 75uM slice8 z7.png');          %S1, Z1
    ML141_75uM.Exp7.roi  {2, 1, 1} = [430; 610; w; 520];
    ML141_75uM.Exp7.roi  {2, 1, 2} = [490; 610; w; 520];
    
    ML141_75uM.Exp7.image{2, 2} = imread('ML141 75uM slice8 z12.png');          %S1, Z1
    ML141_75uM.Exp7.roi  {2, 2, 1} = [430; 660; w; 520];
    ML141_75uM.Exp7.roi  {2, 2, 2} = [490; 610; w; 520];
    
    % 
    %Slice 3______________________________________________________________0
    ML141_75uM.Exp7.image{3, 1} = imread('ML141 75uM slice9.png');          %S1, Z1
    ML141_75uM.Exp7.roi  {3, 1, 1} = [390; 610; w; 470];
    ML141_75uM.Exp7.roi  {3, 1, 2} = [470; 590; w; 620];
    
    
    rmpath('data\Exp7_2024_06_20\ML141 75uM\')

end


%% Old slices/other conditions

% %% LatA 100nM Experiment 1
% addpath('data\Exp1_2023_10_13\LatA 100nM\')
% 
% LatA_100nM.Exp1.date     = datetime(2023, 10, 13);
% LatA_100nM.Exp1.name     = 'LatA 100nM Exp1';
% LatA_100nM.Exp1.dx       = 1/2.35;                                          %um/pixel
% LatA_100nM.Exp1.rotation = [45; 160];                                       %Each index corresponds to slice number
% w = round(roiWidthInMicrons / LatA_100nM.Exp1.dx);                          %Width of roi in pixels
% 
% %First slice_______________________________________________________________
% LatA_100nM.Exp1.image{1, 1} = imread('Lat A 100nM Slice1 z8.png');          %S1, Z1
% LatA_100nM.Exp1.roi  {1, 1} = [520; 300; w; 650];                           %Define roi
% 
% LatA_100nM.Exp1.image{1, 2} = imread('Lat A 100nM Slice1 z13.png');         %S1, Z2
% LatA_100nM.Exp1.roi  {1, 2} = [500; 280; w; 700];                           %Define roi
% 
% LatA_100nM.Exp1.image{1, 3} = imread('Lat A 100nM Slice1 z18.png');         %S1, Z3
% LatA_100nM.Exp1.roi  {1, 3} = [540; 400; w; 500];                           %Define roi
% 
% %Second slice______________________________________________________________
% LatA_100nM.Exp1.image{2, 1} = imread('Lat A 100nM Slice2 z8.png');          %S2, Z1
% LatA_100nM.Exp1.roi  {2, 1} = [550; 460; w; 420];                           %Define roi
% 
% LatA_100nM.Exp1.image{2, 2} = imread('Lat A 100nM Slice2 z13.png');         %S2, Z2
% LatA_100nM.Exp1.roi  {2, 2} = [540; 450; w; 480];                           %Define roi
% 
% LatA_100nM.Exp1.image{2, 3} = imread('Lat A 100nM Slice2 z18.png');         %S2, Z3
% LatA_100nM.Exp1.roi  {2, 3} = [580; 490; w; 420];                           %Define roi
% 
% rmpath('data\Exp1_2023_10_13\LatA 100nM\')
% 
% %% LatA 100nM Experiment 2
% addpath('data\Exp2_2024_02_05\LatA 100nM\')
% 
% LatA_100nM.Exp2.date     = datetime(2024, 2, 5);
% LatA_100nM.Exp2.name     = 'LatA 100nM Exp2';
% LatA_100nM.Exp2.dx       = 1/3.3875;                                              %um/pixel
% LatA_100nM.Exp2.rotation = [-3; 10; 0];                                             %Each index corresponds to slice number
% w = round(roiWidthInMicrons / LatA_100nM.Exp2.dx); 
% 
% %Slice 1___________________________________________________________________
% LatA_100nM.Exp2.image{1, 1} = imread('LatA 100nM Slice1 z9.png');          %S1, Z1
% LatA_100nM.Exp2.roi  {1, 1} = [320; 550; w; 650];                           %Define roi
% 
% %Slice 2___________________________________________________________________
% LatA_100nM.Exp2.image{2, 1} = imread('LatA 100nM Slice3 z11.png');          %S1, Z1
% LatA_100nM.Exp2.roi  {2, 1} = [940; 600; w; 900];
% 
% LatA_100nM.Exp2.image{2, 2} = imread('LatA 100nM Slice3 z21.png');          %S1, Z1
% LatA_100nM.Exp2.roi  {2, 2} = [940; 850; w; 700];
% 
% rmpath('data\Exp2_2024_02_05\LatA 100nM\')
% %% ML141 150uM Experiment 3
% addpath('data\Exp3_2024_03_04\ML141 150uM\')
% 
% ML141_150uM.Exp3.date     = datetime(2024, 3, 4);
% ML141_150uM.Exp3.name     = 'ML141 150uM Exp3';
% ML141_150uM.Exp3.dx       = 1/2.4089;                                       %um/pixel
% ML141_150uM.Exp3.rotation = [-12, 0, 160, 10];                              %Each index corresponds to slice number
% w = round(roiWidthInMicrons / ML141_150uM.Exp3.dx);
% 
% %Slice 1___________________________________________________________________
% ML141_150uM.Exp3.image{1, 1} = imread('ML141 150uM slice1 z15.png');        %S1, Z1
% ML141_150uM.Exp3.roi  {1, 1, 1} = [540; 500; w; 630];                       %Define roi
% ML141_150uM.Exp3.roi  {1, 1, 2} = [660; 640; w; 500]; 
% 
% ML141_150uM.Exp3.image{1, 2} = imread('ML141 150uM slice1 z20.png');        %S1, Z2
% ML141_150uM.Exp3.roi  {1, 2, 1} = [540; 650; w; 500];                       %Define roi
% ML141_150uM.Exp3.roi  {1, 2, 2} = [640; 640; w; 500]; 
% 
% %Slice 2___________________________________________________________________
% ML141_150uM.Exp3.image{2, 1} = imread('ML141 150uM slice2 z13.png');        %S2, Z1
% ML141_150uM.Exp3.roi  {2, 1, 1} = [400; 560; w; 520];                       %Define roi
% 
% ML141_150uM.Exp3.image{2, 2} = imread('ML141 150uM slice2 z18.png');        %S2, Z2
% ML141_150uM.Exp3.roi  {2, 2, 1} = [410; 530; w; 520];                       %Define roi
% 
% ML141_150uM.Exp3.image{2, 3} = imread('ML141 150uM slice2 z23.png');        %S2, Z3
% ML141_150uM.Exp3.roi  {2, 3, 1} = [430; 530; w; 520];                       %Define roi
% 
% %Slice 3___________________________________________________________________
% 
% ML141_150uM.Exp3.image{3, 1} = imread('ML141 150uM slice3 z9.png');         
% ML141_150uM.Exp3.roi  {3, 1, 1} = [660; 520; w; 630];                       %S3, Z1, R1
% ML141_150uM.Exp3.roi  {3, 1, 2} = [790; 590; w; 550];                       %S3, Z1, R2   
% 
% ML141_150uM.Exp3.image{3, 2} = imread('ML141 150uM slice3 z14.png');        
% ML141_150uM.Exp3.roi  {3, 2, 1} = [650; 520; w; 630];                       %S3, Z2, R1
% ML141_150uM.Exp3.roi  {3, 2, 2} = [750; 590; w; 550];                       
% 
% ML141_150uM.Exp3.image{3, 3} = imread('ML141 150uM slice3 z19.png');        %S3, Z3
% ML141_150uM.Exp3.roi  {3, 3, 1} = [630; 620; w; 530];                       %Define roi
% ML141_150uM.Exp3.roi  {3, 3, 2} = [740; 620; w; 530]; 
% 
% %Slice 4___________________________________________________________________
% 
% ML141_150uM.Exp3.image{4, 1} = imread('ML141 150uM slice4 z14.png');        %S4, Z1
% ML141_150uM.Exp3.roi  {4, 1, 1} = [400; 250; w; 500];                       %Define roi
% ML141_150uM.Exp3.roi  {4, 1, 2} = [550; 250; w; 500]; 
% 
% ML141_150uM.Exp3.image{4, 2} = imread('ML141 150uM slice4 z20.png');        %S4, Z2
% ML141_150uM.Exp3.roi  {4, 2, 1} = [450; 250; w; 500];                       %Define roi
% ML141_150uM.Exp3.roi  {4, 2, 2} = [600; 250; w; 530]; 
% 