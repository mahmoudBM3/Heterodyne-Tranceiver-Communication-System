n=2;
F=zeros(1,5);
[BBCArabic2,F(1)]= audioread('Short_BBCArabic2.wav');
%Changing BBCArabic2 to mono.
BBCArabic2_Mono = (BBCArabic2(:,1)+BBCArabic2(:,2));
[FM9090,F(2)]= audioread('Short_FM9090.wav');
%Changing FM9090 to mono.
FM9090_Mono = (FM9090(:,1)+FM9090(:,2));
[QuranPalestine,F(3)]= audioread('Short_QuranPalestine.wav');
%Changing QuranPalestine to mono.
QuranPalestine_Mono = (QuranPalestine(:,1)+QuranPalestine(:,2));
[RussianVoice,F(4)]= audioread('Short_RussianVoice.wav');
%Changing RussianVoice to mono.
RussianVoice_Mono = (RussianVoice(:,1)+RussianVoice(:,2));
[SkyNewsArabia,F(5)]= audioread('Short_SkyNewsArabia.wav');
%Changing SkyNewsArabia to mono.
SkyNewsArabia_Mono = (SkyNewsArabia(:,1)+SkyNewsArabia(:,2));
%determining the longest length of the samples.
len= zeros(1,6);
len(1)=length(BBCArabic2_Mono);
len(2)=length(FM9090_Mono);
len(3)=length(QuranPalestine_Mono);
len(4)=length(RussianVoice_Mono);
len(5)=length(SkyNewsArabia_Mono);
len(6)=len(1);
for k = 2:6
    if len(6)<len(k)
        len(6)=len(k);
    end
end
%Padding the 5 signals to make them of equal lenths.
x = len(6)-len(1);
BBCArabic2_Mono = [BBCArabic2_Mono; zeros(x,1)];
x = len(6)-len(2);
FM9090_Mono = [FM9090_Mono; zeros(x,1)];
x = len(6)-len(3);
QuranPalestine_Mono = [QuranPalestine_Mono; zeros(x,1)];
x = len(6)-len(4);
RussianVoice_Mono = [RussianVoice_Mono; zeros(x,1)];
x = len(6)-len(5);
SkyNewsArabia_Mono = [SkyNewsArabia_Mono; zeros(x,1)];
%putting all the samples in one array.
Samples=[BBCArabic2_Mono FM9090_Mono QuranPalestine_Mono RussianVoice_Mono SkyNewsArabia_Mono];
interpolatedmessage=interp(Samples(:,4),10);
interpolatedmessage2=interp(Samples(:,2),10);
fs=441000;
figure('Name','Message');
plotfft(interpolatedmessage,fs/2);
t=0:1/(fs):(length(interpolatedmessage)-1)/fs;
fc1=100000;%n=1%
fc2=150000;%n=2%
interpolatedmessage=interpolatedmessage';
interpolatedmessage2=interpolatedmessage2';
carrier1=cos(2*pi*fc1*t);
carrier2=cos(2*pi*fc2*t);
modulatedmessage=interpolatedmessage.*carrier1+interpolatedmessage2.*carrier2;
figure('Name','Modulated message');
plotfft(modulatedmessage,fs/2);
%**************************************************************************%
%Start of Receiver%
if n==1
rffilteredmessage=filter(RFBPF,modulatedmessage);
figure('Name','RF BPF Output');
plotfft(rffilteredmessage,fs/2);
elseif n==2
rffilteredmessage=filter(RFBPF2,modulatedmessage);
figure('Name','RF BPF Output');
plotfft(rffilteredmessage,fs/2);
end
%IF Conversion%
if n==1
    fc=100000;
elseif n==2
    fc=150000;
end
fif=25000;
ifcarrier=cos(2*pi*(fif+fc)*t);
ifmessage=rffilteredmessage.*ifcarrier;
figure('Name','IF Output');
plotfft(ifmessage,fs/2);
iffilteredmessage=filter(IFBPF,ifmessage);
figure('Name','IF Filter Output');
plotfft(iffilteredmessage,fs/2);
ifcarrier2=cos(2*pi*(fif)*t);
basebandmessage=iffilteredmessage.*ifcarrier2;
receivedmessage=filter(LPF,basebandmessage);
figure('Name','Received message');
plotfft(receivedmessage,fs/2);
finalmessage=downsample(receivedmessage,10);
sound((5*finalmessage),44100);