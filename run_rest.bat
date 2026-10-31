@echo off
call .venv\Scripts\activate

rem --- carried over from last time ---
call :run ref_s2 --seed 2
call :run C_w20_s0 --window 20
call :run C_w60_s0 --window 60

rem --- Part D ---
call :run D_full_s0   --weight-decay 1e-4 --augment
call :run D_nodrop_s0 --weight-decay 1e-4 --augment --dropout 0
call :run D_nowd_s0   --augment
call :run D_noaug_s0  --weight-decay 1e-4

rem --- Parts E and F: only works after the train.py edits. Remove "rem" to enable ---
call :run E_warmup_s0 --warmup-epochs 5
call :run F_focal_s0  --loss focal --focal-gamma 2

rem --- extra seeds for the two surprising results (nice to have) ---
call :run B_conv2_s1 --n-conv 2 --seed 1
call :run B_conv2_s2 --n-conv 2 --seed 2
call :run A_gru_s1 --rnn gru --seed 1
call :run A_gru_s2 --rnn gru --seed 2

python summarize.py
echo ALL DONE
goto :eof

:run
set NAME=%1
shift
if exist runs\%NAME%\metrics.json (echo skip %NAME% & goto :eof)
python train.py --name %NAME% %1 %2 %3 %4 %5 %6 %7 %8
goto :eof