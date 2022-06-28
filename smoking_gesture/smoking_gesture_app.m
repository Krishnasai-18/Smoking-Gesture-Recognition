function varargout = smoking_gesture_app(varargin)
% SMOKING_GESTURE_APP MATLAB code for smoking_gesture_app.fig
%      SMOKING_GESTURE_APP, by itself, creates a new SMOKING_GESTURE_APP or raises the existing
%      singleton*.
%
%      H = SMOKING_GESTURE_APP returns the handle to a new SMOKING_GESTURE_APP or the handle to
%      the existing singleton*.
%
%      SMOKING_GESTURE_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMOKING_GESTURE_APP.M with the given input arguments.
%
%      SMOKING_GESTURE_APP('Property','Value',...) creates a new SMOKING_GESTURE_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before smoking_gesture_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to smoking_gesture_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help smoking_gesture_app

% Last Modified by GUIDE v2.5 25-Apr-2019 15:54:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smoking_gesture_app_OpeningFcn, ...
                   'gui_OutputFcn',  @smoking_gesture_app_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before smoking_gesture_app is made visible.
function smoking_gesture_app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to smoking_gesture_app (see VARARGIN)

% Choose default command line output for smoking_gesture_app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes smoking_gesture_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = smoking_gesture_app_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% function [ handles ] = drowsiness_det( handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% 
% clear all;
% close all;
% clc




videoFileReader = vision.VideoFileReader('VID-20190423-WA0002.mp4');
% videoFileReader = vision.VideoFileReader('VID-20190423-WA0003.mp4');



videoFrame      = step(videoFileReader);
[row col t]=size(videoFrame);


no_frame=1;

% tic;
faceDetector = vision.CascadeObjectDetector();
% bbox            = step(faceDetector, Gray_frame2);


frame_count=0;
eye_sleep_cnt=0;
while ~isDone(videoFileReader)
%     pause(2)

    frame_count=frame_count+1
    [videoFrame ] = step(videoFileReader);
%     axes(handles.axe1)
%     imshow(videoFrame)
   
   gray_frame = rgb2gray(videoFrame);
% 
% axes(handles.axes1)
%     imshow(gray_frame)
    
%     vid=videoinput('winvideo',1);                                             %sets videoinput to the webcam, and the webcam device 1
%figure(3);preview(vid);                                                  %displays the webcam input
% figure(1);
% set(vid,'ReturnedColorspace','rgb')
% pause(2); 
if(frame_count==1)

% pause 2 seconds before snapshot of background image
% IM1=getsnapshot(vid); 
IM1=videoFrame; 
axes(handles.axes1)
imshow(IM1);
title('Background')
%get snapshot from the webcam video and store to IM1 variable
% figure(1);subplot(3,3,1);imshow(IM1);title('Background');                 %open up a figure and show the image stored in IM1 variable
end
% pause(2);                                                                 %pause a second before taking the test image snapshot
% IM2=getsnapshot(vid);
IM2=videoFrame;

%get snapshot of test image and store to variable IM2
% figure(1);subplot(3,3,2);
axes(handles.axes2)
imshow(IM2);title('Gesture');                    %open up a figure and show the image stored in IM2 variable
IM3 = IM1 - IM2;                                                            %subtract Backround from Image
% figure(1);subplot(3,3,3);
axes(handles.axes3)
imshow(IM3);title('Subtracted');                   %show the subtracted image
IM3 = rgb2gray(IM3); 
%Converts RGB to Gray
% figure(1);subplot(3,3,4);
axes(handles.axes4)
imshow(IM3);title('Grayscale');                    %Display Gray Image
lvl = graythresh(IM3);                                                      %find the threshold value using Otsu's method for black and white

IM3 = im2bw(IM3, lvl);                                                      %Converts image to BW, pixels with value higher than threshold value is changed to 1, lower changed to 0


% figure(1);subplot(3,3,5);
axes(handles.axes5)
imshow(IM3);title('Black&White');                  %display black and white image

IM3 = bwareaopen(IM3, 10000);
IM3 = imfill(IM3,'holes');

% figure(1);subplot(3,3,6);
axes(handles.axes6)
imshow(IM3);title('Small Areas removed & Holes Filled');  

IM3 = imerode(IM3,strel('disk',15));                                        %erode image
IM3 = imdilate(IM3,strel('disk',20));                                       %dilate iamge
IM3 = medfilt2(IM3, [5 5]);                                                 %median filtering
% figure(1);subplot(3,3,7);
axes(handles.axes7)
imshow(IM3);title('Eroded,Dilated & Median Filtered');  
IM3 = bwareaopen(IM3, 10000);                                               %finds objects, noise or regions with pixel area lower than 10,000 and removes them
% figure(1);subplot(3,3,8);
axes(handles.axes8)
imshow(IM3);title('Processed');                    %displays image with reduced noise
IM3 = flipdim(IM3,1);                                                       %flip image rows
% figure(1);subplot(3,3,9);imshow(IM3);title('Flip Image');   


REG=regionprops(IM3,'all');                                                 %calculate the properties of regions for objects found 
CEN = cat(1, REG.Centroid);                                                 %calculate Centroid
[B, L, N, A] = bwboundaries(IM3,'noholes');                                 %returns the number of objects (N), adjacency matrix A, object boundaries B, nonnegative integers of contiguous regions L

RND = 0;                                                                    % set variable RND to zero; to prevent errors if no object detected

pkNo=0;
pkNo_STR=0;
%calculate the properties of regions for objects found
    for k =1:length(B)                                                      %for the given object k
            PER = REG(k).Perimeter;                                         %Perimeter is set as perimeter calculated by region properties 
            ARE = REG(k).Area;                                              %Area is set as area calculated by region properties
            RND = (4*pi*ARE)/(PER^2);                                       %Roundness value is calculated
            
            BND = B{k};                                                     %boundary set for object
            BNDx = BND(:,2);                                                %Boundary x coord
            BNDy = BND(:,1);                                                %Boundary y coord
            
            pkoffset = CEN(:,2)+.5*(CEN(:,2));                             %Calculate peak offset point from centroid
            [pks,locs] = findpeaks(BNDy,'minpeakheight',pkoffset);         %find peaks in the boundary in y axis with a minimum height greater than the peak offset
            pkNo = size(pks,1);                                            %finds the peak Nos
            pkNo_STR = sprintf('%2.0f',pkNo);                              %puts the peakNo in a string
            
%             figure(2);imshow(IM3);
%             hold on
%             plot(BNDx, BNDy, 'b', 'LineWidth', 2);                          %plot Boundary
%             plot(CEN(:,1),CEN(:,2), '*');                                   %plot centroid
%             plot(BNDx(locs),pks,'rv','MarkerFaceColor','r','lineWidth',2);  %plot peaks
%             hold off
    
    end
                                                                            % roundness is useful, for an object of same shape ratio, regardless of
                                                                            % size the roundess value remains the same. For instance, a circle with
                                                                            % radius 5pixels will have the same roundness as a circle with radius
                                                                            % 100pixels. It is a measure of how round an object is.
                                                                            
    % Identification Codes, You might need to change these
    
    CHAR_STR = 'not identified';                                            %sets char_str value to 'not identified'
    if RND >0.19 && RND < 0.24 && pkNo ==3
        CHAR_STR = 'W';
    elseif RND >0.44 && RND < 0.47  && pkNo ==1
        CHAR_STR = 'O';
        
    elseif RND >0.37 && RND < 0.40 && pkNo ==2
        CHAR_STR = 'R';
    elseif RND >0.40 && RND < 0.43 && pkNo == 3
        CHAR_STR = 'D';
    else
        CHAR_STR = 'not identified';
    end
    
%     if(
%         
%         set(handles.text3, 'String', CHAR_STR);
    pkNo
    pkNo_STR
    CHAR_STR
    set(handles.text1, 'String', pkNo);
    set(handles.text2, 'String', pkNo_STR);
    set(handles.text3, 'String', CHAR_STR);
%         if(pkNo_STR==1 || pkNo==1 )
%             aa=3;
%       set(handles.text5, 'String', 'suspecious -smoking activity');
%     else
%         set(handles.text5, 'String', '');
%     end
%     text(20,20,CHAR_STR,'color','r','Fontsize',18);                         %place text in x=20,y=20 on the figure with the value of Char_str in redcolour with font size 18
%     text(20,100,['RND: ' sprintf('%f',RND)],'color','r','Fontsize',18);
%     text(20,180,[
    

 
end











   


release(videoPlayer);
% release(videoFReader);

%%%%%%%%%live
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clc




% videoFileReader = vision.VideoFileReader('VID-20190423-WA0002.mp4');
videoFileReader = vision.VideoFileReader('VID-20190423-WA0003.mp4');



videoFrame      = step(videoFileReader);
[row col t]=size(videoFrame);


no_frame=1;

% tic;
faceDetector = vision.CascadeObjectDetector();
% bbox            = step(faceDetector, Gray_frame2);


frame_count=0;
eye_sleep_cnt=0;

aa=webcam;
pkNo_count=0;
    pkNo_STR_count=0;
% while ~isDone(videoFileReader)
while frame_count<100
%     pause(2)

    frame_count=frame_count+1
%     [videoFrame ] = step(videoFileReader);
videoFrame=snapshot(aa);
%     axes(handles.axe1)
%     imshow(videoFrame)
   
   gray_frame = rgb2gray(videoFrame);
% 
% axes(handles.axes1)
%     imshow(gray_frame)
    
%     vid=videoinput('winvideo',1);                                             %sets videoinput to the webcam, and the webcam device 1
%figure(3);preview(vid);                                                  %displays the webcam input
% figure(1);
% set(vid,'ReturnedColorspace','rgb')
% pause(2); 
if(frame_count==1)

% pause 2 seconds before snapshot of background image
% IM1=getsnapshot(vid); 
IM1=videoFrame; 
axes(handles.axes1)
imshow(IM1);
title('Background')
%get snapshot from the webcam video and store to IM1 variable
% figure(1);subplot(3,3,1);imshow(IM1);title('Background');                 %open up a figure and show the image stored in IM1 variable
end
% pause(2);                                                                 %pause a second before taking the test image snapshot
% IM2=getsnapshot(vid);
IM2=videoFrame;

%get snapshot of test image and store to variable IM2
% figure(1);subplot(3,3,2);
axes(handles.axes2)
imshow(IM2);title('Gesture');                    %open up a figure and show the image stored in IM2 variable
IM3 = IM1 - IM2;                                                            %subtract Backround from Image
% figure(1);subplot(3,3,3);
axes(handles.axes3)
imshow(IM3);title('Subtracted');                   %show the subtracted image
IM3 = rgb2gray(IM3); 
%Converts RGB to Gray
% figure(1);subplot(3,3,4);
axes(handles.axes4)
imshow(IM3);title('Grayscale');                    %Display Gray Image
lvl = graythresh(IM3);                                                      %find the threshold value using Otsu's method for black and white

IM3 = im2bw(IM3, lvl);                                                      %Converts image to BW, pixels with value higher than threshold value is changed to 1, lower changed to 0


% figure(1);subplot(3,3,5);
axes(handles.axes5)
imshow(IM3);title('Black&White');                  %display black and white image

IM3 = bwareaopen(IM3, 10000);
IM3 = imfill(IM3,'holes');

% figure(1);subplot(3,3,6);
axes(handles.axes6)
imshow(IM3);title('Small Areas removed & Holes Filled');  

IM3 = imerode(IM3,strel('disk',15));                                        %erode image
IM3 = imdilate(IM3,strel('disk',20));                                       %dilate iamge
IM3 = medfilt2(IM3, [5 5]);                                                 %median filtering
% figure(1);subplot(3,3,7);
axes(handles.axes7)
imshow(IM3);title('Eroded,Dilated & Median Filtered');  
IM3 = bwareaopen(IM3, 10000);                                               %finds objects, noise or regions with pixel area lower than 10,000 and removes them
% figure(1);subplot(3,3,8);
axes(handles.axes8)
imshow(IM3);title('Processed');                    %displays image with reduced noise
IM3 = flipdim(IM3,1);                                                       %flip image rows
% figure(1);subplot(3,3,9);imshow(IM3);title('Flip Image');   


REG=regionprops(IM3,'all');                                                 %calculate the properties of regions for objects found 
CEN = cat(1, REG.Centroid);                                                 %calculate Centroid
[B, L, N, A] = bwboundaries(IM3,'noholes');                                 %returns the number of objects (N), adjacency matrix A, object boundaries B, nonnegative integers of contiguous regions L

RND = 0;                                                                    % set variable RND to zero; to prevent errors if no object detected

pkNo=0;
pkNo_STR=0;
%calculate the properties of regions for objects found
    for k =1:length(B)                                                      %for the given object k
            PER = REG(k).Perimeter;                                         %Perimeter is set as perimeter calculated by region properties 
            ARE = REG(k).Area;                                              %Area is set as area calculated by region properties
            RND = (4*pi*ARE)/(PER^2);                                       %Roundness value is calculated
            
            BND = B{k};                                                     %boundary set for object
            BNDx = BND(:,2);                                                %Boundary x coord
            BNDy = BND(:,1);                                                %Boundary y coord
            
            pkoffset = CEN(:,2)+.5*(CEN(:,2));                             %Calculate peak offset point from centroid
            [pks,locs] = findpeaks(BNDy,'minpeakheight',pkoffset);         %find peaks in the boundary in y axis with a minimum height greater than the peak offset
            pkNo = size(pks,1);                                            %finds the peak Nos
            pkNo_STR = sprintf('%2.0f',pkNo);                              %puts the peakNo in a string
            
%             figure(2);imshow(IM3);
%             hold on
%             plot(BNDx, BNDy, 'b', 'LineWidth', 2);                          %plot Boundary
%             plot(CEN(:,1),CEN(:,2), '*');                                   %plot centroid
%             plot(BNDx(locs),pks,'rv','MarkerFaceColor','r','lineWidth',2);  %plot peaks
%             hold off
    
    end
                                                                            % roundness is useful, for an object of same shape ratio, regardless of
                                                                            % size the roundess value remains the same. For instance, a circle with
                                                                            % radius 5pixels will have the same roundness as a circle with radius
                                                                            % 100pixels. It is a measure of how round an object is.
                                                                            
  
    
    CHAR_STR = 'not identified';                                            %sets char_str value to 'not identified'
    if RND >0.19 && RND < 0.24 && pkNo ==3
        CHAR_STR = 'W';
    elseif RND >0.44 && RND < 0.47  && pkNo ==1
        CHAR_STR = 'O';
        
    elseif RND >0.37 && RND < 0.40 && pkNo ==2
        CHAR_STR = 'R';
    elseif RND >0.40 && RND < 0.43 && pkNo == 3
        CHAR_STR = 'D';
    else
        CHAR_STR = 'not identified';
    end
    
%     if(
%         
%         set(handles.text3, 'String', CHAR_STR);
    pkNo
    pkNo_STR
    CHAR_STR
    set(handles.text1, 'String', pkNo);
    set(handles.text2, 'String', pkNo_STR);
    set(handles.text3, 'String', CHAR_STR);
    
    pkNo_count=pkNo_count + pkNo;
    pkNo_STR_count=pkNo_STR_count+pkNo_STR;
%     time_stamp=clock;
%     name_img=num2str(time_stamp);
%     format='.jpg';
%     image_name=[name_img format];
    id='krishnasaimodali';
    if(pkNo_count>7)
         time_stamp=clock;
    name_img=num2str(time_stamp);
    format='.jpg';
    image_name=[name_img format];
        imwrite(videoFrame,image_name);
        imwrite(videoFrame,'person_face.jpg');
         set(handles.text5, 'String', 'suspecious -smoking activity');
         message_body='suspecious activity detected ';
message_subject='Please start investigation ';
send_mail_message(id,message_body,message_subject,'person_face.jpg')

         set(handles.text5, 'String', 'mail-sent');
         
    else
        set(handles.text5, 'String', '');
    end
        
        
%     if(pkNo_STR==1 || pkNo==1 )
%       set(handles.text5, 'String', 'suspecious -smoking activity');
%     else
%         set(handles.text5, 'String', '');
%     end
%     text(20,20,CHAR_STR,'color','r','Fontsize',18);                         %place text in x=20,y=20 on the figure with the value of Char_str in redcolour with font size 18
%     text(20,100,['RND: ' sprintf('%f',RND)],'color','r','Fontsize',18);
%     text(20,180,[
    

 
end











   


% release(videoPlayer);
% release(videoFReader)
