#include "mbed.h"
#include "TS_DISCO_F429ZI.h"
#include "LCD_DISCO_F429ZI.h"

LCD_DISCO_F429ZI lcd;
TS_DISCO_F429ZI ts;

InterruptIn user_button(USER_BUTTON);

extern "C" int32_t CountItems();
extern "C" int32_t SumFrequencies();
extern "C" uint8_t * GetWordAt(int32_t i);
extern "C" int16_t GetFreqAt(int32_t i); 



void button_released(){
   
     lcd.SetBackColor(LCD_COLOR_BLUE);
    lcd.SetTextColor(LCD_COLOR_WHITE);
    lcd.FillCircle(100, 100, 50); 
    }

void button_pressed(){
    lcd.Clear(LCD_COLOR_YELLOW);

}


void push_button_Callback() // Only executes when button interrupt received
{

    user_button.rise(&button_pressed);
    user_button.fall(&button_released);   
}


void GetFreq(int32_t & words, int32_t & frequencies){
        uint8_t text[30];

    words = CountItems();
    frequencies = SumFrequencies();        
    
     sprintf((char*)text, "frequencies:%d", frequencies);
        lcd.DisplayStringAt(0, LINE(3), (uint8_t *)&text, LEFT_MODE);
    }
    
    
void GetWords(int32_t &words, int32_t & frequencies){
           uint8_t text[30];

        frequencies = SumFrequencies();        
        words = CountItems();
 
      sprintf((char*)text, "words:%d", words);
        lcd.DisplayStringAt(0, LINE(2), (uint8_t *)&text, LEFT_MODE);
    }

int main()
{
    int32_t words;
    int32_t frequencies;
    uint8_t status;
    uint8_t text[30];
    uint8_t * word;
    int32_t freq;
    double percentage;    
 
    //GET WORD AND FREQUEN
      GetWords(words, frequencies);
      GetFreq(words,frequencies);
 
       //CALL BACK
   push_button_Callback();
    
    while(1){
                 
    //GET STRING AT I
  for(int i = 0; i <words; i++){
        //GET WORD AT I
        word = GetWordAt(i);
        sprintf((char*)text, "Word:%s", word);
        lcd.DisplayStringAt(0, LINE(6), (uint8_t *)&text, LEFT_MODE);
         //GET FREQUENCY AT I
         freq = GetFreqAt(i); 
          sprintf((char*)text, "freq:%d", freq);
        lcd.DisplayStringAt(0, LINE(4), (uint8_t *)&text, LEFT_MODE);
        //freq/total
        percentage = (float) frequencies/ (float) freq;
        
       }
                
  }

    
   
}
