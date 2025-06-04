import numpy as np
import adi
import matplotlib.pyplot as plt
import time

# Set parameters for sample rates and buffer size
sample_rate = 10e6  # 10 MHz
center_freq = 100e6  # 100 MHz
buffer_size = 2**15  # 32768 samples

# Initialize PlutoSDR
sdr = adi.Pluto("ip:192.168.2.1")
sdr.rx_buffer_size = buffer_size

# Configure the PlutoSDR
sdr.sample_rate = int(sample_rate)
sdr.rx_rf_bandwidth = int(sample_rate)
sdr.center_freq = center_freq  # Set center frequency to 100 MHz

# Start a timer and begin receiving samples
start_time = time.time()
num_samples_received = 0

# Read and count samples
while time.time() - start_time < 1:
    samples = sdr.rx()
    num_samples_received += len(samples)

# Calculate sample rate
end_time = time.time()
elapsed_time = end_time - start_time
calculated_sample_rate = num_samples_received / elapsed_time 

print(f"Received {num_samples_received} samples in {elapsed_time:.2f} seconds.")
print(f"Achieved Sample Rate: {calculated_sample_rate:.2f} samples per second.")
