#!/bin/bash

source /neural-compressor/.azure-pipelines/scripts/change_color.sh
mkdir -p /neural-compressor/.azure-pipelines/scripts/codeScan/scanLog
pylint_log_dir="/neural-compressor/.azure-pipelines/scripts/codeScan/scanLog"

pip install -r /neural-compressor/requirements.txt
pip install torch==1.12.0

python -m pylint -f json --disable=R,C,W,E1129 --enable=line-too-long --max-line-length=120 --extension-pkg-whitelist=numpy --ignored-classes=TensorProto,NodeProto --ignored-modules=tensorflow,torch,torch.quantization,torch.tensor,torchvision,mxnet,onnx,onnxruntime,intel_extension_for_pytorch /neural-compressor/neural_compressor > $pylint_log_dir/lpot-pylint.json
exit_code=$?

# code-scan close 
RESET="echo -en \\E[0m \\n"

$BOLD_YELLOW && echo " -----------------  Current pylint cmd start --------------------------" && $RESET
echo "python -m pylint -f json --disable=R,C,W,E1129 --enable=line-too-long --max-line-length=120 --extension-pkg-whitelist=numpy --ignored-classes=TensorProto,NodeProto --ignored-modules=tensorflow,torch,torch.quantization,torch.tensor,torchvision,mxnet,onnx,onnxruntime,intel_extension_for_pytorch /neural-compressor/neural_compressor > $pylint_log_dir/lpot-pylint.json"
$BOLD_YELLOW && echo " -----------------  Current pylint cmd end --------------------------" && $RESET

$BOLD_YELLOW && echo " -----------------  Current log file output start --------------------------" && $RESET
cat  $pylint_log_dir/lpot-pylint.json
$BOLD_YELLOW && echo " -----------------  Current log file output end --------------------------" && $RESET


if [ ${exit_code} -ne 0 ] ; then
    $BOLD_RED && echo "Error!! Please Click on the artifact button to download and view Pylint error details." && $RESET; exit 1
fi
$BOLD_PURPLE && echo "Congratulations, Pylint check passed!" && $LIGHT_PURPLE && echo " You can click on the artifact button to see the log details." && $RESET; exit 0