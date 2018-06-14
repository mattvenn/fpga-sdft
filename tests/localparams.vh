// fft settings
localparam freq_bins = 32;
localparam bin_addr_w = $clog2(freq_bins);
localparam data_width = 8;
localparam freq_data_w = 20; // to prevent overflow with multiplies and adds

// test settings
localparam sample_low = 20;
localparam sample_high = 150;

// actually way too fast, results in bram being updated many times per video frame
localparam FFT_READ_CYCLES = 100; // MAX 127! every X cycles read the next freq/imag bin into BRAM

// fsm values
localparam STATE_WAIT_FFT   = 0;
localparam STATE_WAIT_START = 1;
localparam STATE_PROCESS    = 2;
localparam STATE_READ       = 3;
localparam STATE_WRITE_BRAM = 4;

// screen settings
localparam screen_height = 480;

// bar settings
localparam bar_height = screen_height / freq_bins;
localparam bar_height_counter_w = $clog2(bar_height);
