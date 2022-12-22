function plotfft(message,fms)
messagefft=abs(fft(message));
N=length(messagefft);
k=-N/2:N/2-1;
plot(k*2*fms/N,fftshift(messagefft));
end