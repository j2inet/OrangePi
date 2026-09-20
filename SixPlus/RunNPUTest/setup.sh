echo -e "\a"
clear
echo "This script must be run from within an Anaconda created Python 3.11 environment."

sleep 3

echo "Installing dependencies"
sudo apt-get install - python3-pip cmake 
echo "\x1b[37m--Installing modelscope\x1b[0m"
pip3 install modelscope --break-system-packages \
  -i https://repo.huaweucloud.com/repository/pypi/simple \
  --trusted-host repo.huaweicloud.com

#echo "installing python3-pip"
# sudo apt-get install -y python3-pip
#pip3 install modelscope \
#   -i https://repo.huaweicloud.com/repository/pypi/simple \
#   --trusted-host repo.huaweicloud.com

echo "updating path"
export PATH="$HOME/.local.bin:$PATH"

echo "Installing torch"
python3 -m pip install tqdm torch torchvision torchaudio transformers ffmpeg


echo  "downloading model with modelscope"
modelscope download --model cix/ai_model_hub_25_Q3 \
  --local_dir  ~/ai_model_hub_25_Q3
  
ls ~/ai_model_hub_25_Q3

## Note that there is a Git pathway too for installing modelscope. 
## See the Orange Pi documentation for more. 

## ----Install NPU Dependencies
cd ~/ai_model_hub_25_Q3
echo "Installing Requirements"
pip3 install -r requirements.txt \
   --break-system-packages -i https://repo.huaweicloud.com/repository/pypi/simple \
   --trusted-host repo.huaweicloud.com

echo "Checking for the AIPU Kernel Modules"
lsmod | grep aipu
ls /dev/aipu

echo "Checking for libnoe and Zhouyi modules"
pip3 list | grep libnoe
pip3 list | grep Zhouyi

echo "CIX-NEO-UMD must be version 2.0.2 or greater"
dpkg -l | grep cix-umd
dpkg -l | grep cix-npu-onnxruntime

#removing conflicting modules
echo "removing  conflicting module onnxruntime"
pip3 uninstall -y onnxruntime --break-system-packages

##Though the following was in the user manual, it fails. However, I found that
## for the Ubuntu image that I used, this wasn't necessary. Perhaps it is 
## necessary in an environment made with anaconda(?). 
echo "Installing Zhouyi package from local source"
python3 -m pip  install \
   /usr/share/cix/pypi/onnxruntime_zhouyi-1.20.0-cp311-cp311-linux_aarch64.whl \
   --break-system-packages --force-reinstall
   -i https://repo.huaweicloud.com/repository/pypi/simple/
   --trusted-host repo.huaweicloud.com

python3 -m pip uninstall -y ffmpeg ffmpeg-python
python3 -m pip install ffmpeg-python

python3 -m pip install \
/usr/share/cix/pypi/ZhouyiOperators_x2-25.4.23-py3-none-any.whl \
   --break-system-packages--force-reinstall \
  -i https://repo.huaweicloud.com/repository/pypi/simple \
  --trusted-host repo.huaweicloud.com


python3 -m pip install \
  /usr/share/cix/pypi/libnoe-2.0.1-py3-none-manylinux2014_aarch64.whl \
  --break-system-packages --force-reinstall \
  -i https://repo.huaweicloud.com/repository/pypi/simple \
  --trusted-host repo.huaweicloud.com

echo "The following should print 25.4.23 or higher."
pip3 list | grep Zhouyi
echo "The following should print 1.20.0 or higher for onnxruntime-zhoui."
pip3 list | grep onnxruntime-zhouyi
echo "The following should print 2.0.2 or higher."
pip3 list | grep cix-noe-umd
echo "The following should print 2.0.1 or higher."
pip3 list | grep libnoe
sleep 5
clear;

echo "Running Whisper on CPU as a test. Your CPU fan is about to rev up."
cd ~/ai_model_hub_25_Q3/models/Audio/Speech_Recognotion/onnx_whisper_medium_multilingual
pwd

###
echo "--[NPU"
python3 inference_npu.py  --backend npu --encoder_model_path whisper_medium_multilingual_encoder.cix  --language en
echo "--[NPU.2"
python3 inference_npu.py  --backend npu --encoder_model_path whisper_medium_multilingual_encoder.cix
echo "--[NPU.3"
python3 inference_npu.py  --backend npu --encoder_model_path whisper_medium_multilingual_encoder.cix --decoder_model_path whisper_medium_multilingual_decoder.cix
ls out
ls output/

echo "retrying in 3 seconds"; sleep 3;
cat output/test_audio_npu.txt
python3 inference_onnx.py
python3 inference_npu.py  --backend npu --encoder_model_path whisper_medium_multilingual_encoder.cix --decoder_model_path whisper_medium_multilingual_decoder.cix
python3 inference_onnx.py

###
clear;
echo "Running inference on CPU-1"
python3 inference_onnx.py
cat output/test/audio/onnx.txt
echo "Running inference on NPU-2"
python3 inference_npu.py --backend npu \
   --encoder_model_path whisper_medium_multilingual_encoder.cix \
   --decoder_model_path whisper_medium_multilingual_decoder.cix
echo "Printing output
cat output/test_audio_npu.txt
sleep 3; clear;

cd ~/ai_model_hub_25_Q3/models/Audio/Speech_Recognition/onnx_whisper_small_multi_language
echo  "\x1b[34mCPU-2"
python3 inference_onnx.py
echo "\x1b[36mNPU-2"
python inference_npu.py
echo "\x1b[0m;"

cd ~/ai_model_hub_@5_Q3/models/Audio/Speech_Recognition/onnx_whisper_tiny_multi_language
echo "\x1b[34mCPU-3"
python3 inference_onnx.py -audio test_data/1.wav --onnx_path model/whisper_tiny_multilang_encoder.onnx
echo "\x1b[36mNPU-3\x1b[0m"
python3 ingerence_npu.py
echo "\x1b[0m"

#cd ~/ai_model_hub_25_Q3/models/ComputeVision/BEV/onnx_BEV_RoadSeg
#python3 inference_onnx.py
#ls output/onnx_1.png
#python3 inference_npu.py
#ls output/npu_1.png


