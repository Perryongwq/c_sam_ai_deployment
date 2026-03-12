import os
import cv2

import tensorflow as tf
from tensorflow import keras
from keras import models, utils


def predict_img(path):
    img=cv2.cvtColor(cv2.imread(path),cv2.COLOR_BGR2RGB)

    img_array =utils.img_to_array(img)
    img_array =tf.expand_dims(img_array, 0)
    predictions = model.predict(img_array)

    return predictions

modelpath=r"C:\Users\C-SAMAI\Desktop\csam_ai_serverv2\config\model\NFM21HC105.h5"

model=models.load_model(modelpath)

basepath=r"C:\Users\C-SAMAI\Desktop\FMC Images\2025\testimage\v1.1 - v2.0"

onepath=os.path.join(basepath,"0_2_5225_823_672.png")
twopath=os.path.join(basepath,"test654321_testng1 _5237.png")
testpath=os.path.join(basepath,"testchip.png")

print(predict_img(onepath))
print(predict_img(twopath))
print(predict_img(testpath))
