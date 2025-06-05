import numpy as np
import matplotlib.pyplot as plt
import adi

# Initialize PlutoSDR
sdr = adi.Pluto("ip:192.168.2.1")

# Set parameters for sample rates and buffer size
sample_rate = 10e6  # 10 MHz
center_freq = 100e6  # 100 MHz
buffer_size = 2**10  # 1024 samples

# Set general parameters
num_rows = 100
Fs = 1
waterfall_2darr = np.zeros((num_rows, buffer_size))

# Configure the PlutoSDR
sdr.sample_rate = int(sample_rate)
sdr.rx_rf_bandwidth = int(sample_rate)
sdr.center_freq = center_freq  # Set center frequency to 100 MHz

# Create frequency axis for plotting
frequencies = np.fft.fftfreq(buffer_size, 1 / sample_rate)
frequencies = np.fft.fftshift(frequencies)  # Shift the frequency axis

# Create a figure for the spectrogram
plt.figure(figsize=(10, 6))

for i in range(num_rows):
    # Read samples from PlutoSDR
    sample = sdr.rx()

    # Perform FFT on samples
    fft_result = np.fft.fft(sample)

    # Get magnitude of FFT result
    fft_magnitude = np.abs(fft_result)

    # Store magnitude in 2D array
    waterfall_2darr[i, :] = fft_magnitude

    # Plot the spectogram
    plt.clf()
    plt.imshow(waterfall_2darr, aspect='auto', cmap='inferno', origin='lower', extent=[0, num_rows, frequencies[0], frequencies[-1]])
    plt.colorbar(label="Magnitude")
    plt.xlabel("Time (FFT Blocks)")
    plt.ylabel("Frequency (Hz)")

    # Save each image as a file
    plt.savefig(f"spectrogram_{i}.png")

plt.show()