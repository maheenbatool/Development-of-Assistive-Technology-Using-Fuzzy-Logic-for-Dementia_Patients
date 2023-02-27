%{
    part 1: Fuzzy Logic implementation in Image Processing

    This matlab code implementation shows how to use and implement fuzzy logic for image processing. 
    Specifically, this code shows and explains how to detect edges in an image.

    An edge is a limit between two uniform areas. You can distinguish an edge by contrasting the force of adjoining pixels. 
    In any case, since uniform areas are not freshly characterized, 
    little force contrasts between two adjoining pixels don't generally address an edge. 
    All things being equal, the power contrast may address a concealing impact.

%}

%Importing the image.
image1 = imread('image1.jpg');

Imgray = rgb2gray(image1);

% Converting the Image to a Double-Precision Data
% The evalfis function for evaluation of fuzzy inference systems succour only a single precision and double precision data.
% Therefore, convert Imgray into a double array using im2double function.

I = im2double(Imgray);

% Obtaining the Image's Gradient
% The fuzzy logic edge-detection algorithm for this code part
% relies on the image gradient to locate breaks in uniform regions

Gx = [-1 1];
Gy = Gx';
Ix = conv2(I,Gx,'same');
Iy = conv2(I,Gy,'same');


% Defining the  FIS (Fuzzy Inference System) for Edge Detection
% Create an FIS for edge detection,call it edgeFIS

edgeFIS = mamfis('Name','edgeDetection');

% Now Specify the image's gradients, Ix and Iy, as the inputs of edgeFIS initialized above.

edgeFIS = addInput(edgeFIS,[-1 1],'Name','Ix');
edgeFIS = addInput(edgeFIS,[-1 1],'Name','Iy');

% initialize a zero-mean Gaussian membership function for each input.

sx = 0.1;
sy = 0.1;
edgeFIS = addMF(edgeFIS,'Ix','gaussmf',[sx 0],'Name','zero');
edgeFIS = addMF(edgeFIS,'Iy','gaussmf',[sy 0],'Name','zero');

% n/b: the initialized values sx and sy represent the standard deviation (sd) for the 
% zero (0) membership function for the Ix and Iy inputs. 

% Now initialize the intensity of the edge-detected image as an output of the valiable edgeFIS

edgeFIS = addOutput(edgeFIS,[0 1],'Name','Iout');

%Now time to initialize triangular membership functions, white and black, for Iout

wa = 0.1;
wb = 1;
wc = 1;
ba = 0;
bb = 0;
bc = 0.7;
edgeFIS = addMF(edgeFIS,'Iout','trimf',[wa wb wc],'Name','white');
edgeFIS = addMF(edgeFIS,'Iout','trimf',[ba bb bc],'Name','black');

%Test : try and Plot the M (membership) functions of the inputs and outputs of edgeFIS

figure
subplot(2,2,1)
plotmf(edgeFIS,'input',1)
title('Ix')
subplot(2,2,2)
plotmf(edgeFIS,'input',2)
title('Iy')
subplot(2,2,[3 4])
plotmf(edgeFIS,'output',1)
title('Iout')

%include a set of rules to make a pixel white if it belongs to a uniform region and black otherwise.

r1 = "If Ix is zero and Iy is zero then Iout is white";
r2 = "If Ix is not zero or Iy is not zero then Iout is black";
edgeFIS = addRule(edgeFIS,[r1 r2]);
edgeFIS.Rules

% Assess the yield of the edge finder for each line of pixels in I utilizing relating variables Ix and Iy as information inputs.

Ieval = zeros(size(I));
for ii = 1:size(I,1)
    Ieval(ii,:) = evalfis(edgeFIS,[(Ix(ii,:));(Iy(ii,:))]');
end


% Overall Code Test: PLOT RESULT ANALYSIS 
% Plot the original grayscale image

figure
image(I,'CDataMapping','scaled')
colormap('gray')
title('Original Grayscale Image')

% Show and Plot all the detected edges.

figure
image(Ieval,'CDataMapping','scaled')
colormap('gray')
title('Edge Detection Using Fuzzy Logic')


