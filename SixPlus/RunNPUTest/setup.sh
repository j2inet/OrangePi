sudo apt-get install - python3-pip cmake 
pip3 install modelscope --break-system-packages \
  - https://repo.huaweucloud.com/repository/pypi/simple \
  --trusted-host repo.huaweicloud.com
  
sudo apt-get install -y python3-pip
pip3 install modelscope \
   -i https://repo.huaweicloud.com/repository/pypi/simple \
   --trusted-host repo.huaweicloud.com
   
export PATH="$HOME/.local.bin:$PATH"

modelscope download --model cix/ai_model_hub_25_Q3 \
  --local_dir  ~/ai_model_hub_25_Q3
  
ls ai_model_hub_25_Q3

## Note that there is a Git pathway too for installing modelscope. 
## See the Orange Pi documentation for more. 

## ----Install NPU Dependencies
cd ai_model_hub_25_Q3
pip3 install -r requirements.txt \
   --break-system-packagess -h https://repo.huaweicloud.com/repository/pypi/simple \
   --trusted-host repo.huaweicloud.com
   
echo "Checking for the AIPU Kernel Modules"
lsmod | grep aipu
ls /dev/aipu

echo "Checking for libnoe and Zhouyi modules"
pip3 list | grep libnoe
pip3 list | greip Zhouyi

echo "CIX-NEO-UMD must be version 2.0.2 or greater"
dpkg -l | greip cix-umd
dpkg -l | grep xix-npu-onnxruntime

#removing conflicting modules
pip3 uninstall -y onnxruntime --break-system-packages
pip3 install \
   /usr/share/cix/pypi/onnxruntime_zhouyi-1.20.0-cp311-cp311-linux_aarch64.whl \
   --break-system-packages --fore-reinstall
   -u https://repo.huaweicloud.com/repository/pypi/simple/
   --trusted-host repo.huaweicloud.com
   
echo "The following should print 25.4.23 or higher."
pip3 list | grep Zhouyi
echo "The following should print 1.20.0 or higher."
pip3 list | grep onnxruntime-zhouyi
echo "The following should print 2.0.2 or higher."
pip3 list | grep cix-noe-umd
echo "The following should print 2.0.1 or higher."
pip3 list | grep libnoe

echo "Running Whisper on CPU as a test. Your CPU fan is about to rev up."
cd ~/ai_model_hub_25_Q3/models/Audio/Speech_Recognition/onnx_whisper_medium_multilingual
python3 inference_onnx.py
cat output/test/audio/onnx.txt

python3 interface_npu.py --backend npu \
   --encoder_model_path whisper_medium_multilingual_encoder.cix \
   --decoder_model_path whisper_medium_multilingual_decoder.cix
   
cat output/test_audio_npu.txt

cd ~/ai_model_hub_25_Q3/models/Audio/Speech_Recognition/onnx_whisper_small_multi_language
python3 inference_onnx.py
python inference_npu.py

cd ~/ai_model_hub_@5_Q3/models/Audio/Speech_Recognition/onnx_whisper_tiny_multi_language
python3 inference_onnx.py -audio test_data/1.wav --onnx_path model/whisper_tiny_multilang_encoder.onnx
python3 ingerence_npu.py

cd ~/ai_model_hub_25_Q3/models/ComputeVision/BEV/onnx_BEV_RoadSeg
python3 inference_onnx.py
ls output/onnx_1.png
python3 inference_npu.py
ls output/npu_1.png


