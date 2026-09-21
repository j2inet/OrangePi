cd ~/ai_model_hub_25_Q3/models/Audio/Speech_Recognotion/onnx_whisper_medium_multilingual
echo "Running NPU Tests"
python3 inference_npu.py  --backend npu --encoder_model_path whisper_medium_multilingual_encoder.cix --decoder_model_path whisper_medium_multilingual_decoder.cix
ls out
ls output/
echo "continuing  in 3 seconds"; sleep 3;
#cat output/test_audio_npu.txt
echo "End of NPU test output"
echo "--=[running CPU Test"
python3 inference_onnx.py
echo "---==[Running CPU Test"
#python3 inference_npu.py  --backend npu --encoder_model_path whisper_medium_multilingual_encoder.cix --decoder_model_path whisper_medium_multilingual_decoder.cix
#python3 inference_onnx.py