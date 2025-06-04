import numpy as np
import adi
import matplotlib.pyplot as plt
import time

# Initialize PlutoSDR
sdr = adi.Pluto("ip:192.168.2.1")

# Set parameters for sample rates and buffer sizes
sample_rates = [1e6, 2e6, 5e6]
buffer_sizes = [1024, 2048, 4096]
center_freq = 100e6 # Hz

# Read samples for different sample rates and buffer sizes
for rate in sample_rates:
    for size in buffer_sizes:
        sdr.sample_rate = rate
        sdr.buffer_size = size
        num_samples_received = 0
        start_time = time.time()
        
        # Receive samples for 1 second
        while time.time() - start_time < 1:
            samples = sdr.rx()
            num_samples_received += len(samples)
        
        elapsed_time = time.time() - start_time
        calculated_sample_rate = num_samples_received / elapsed_time
        print(f"Sample Rate: {rate}, Buffer Size: {size} => Received {num_samples_received} samples in {elapsed_time:.2f} seconds, Achieved Rate: {calculated_sample_rate:.2f} samples/sec")
