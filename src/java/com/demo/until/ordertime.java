package com.demo.until;

import java.util.Date;
import java.util.Random;

public class ordertime {
    public static String getOrderIdByTime() {
        Date date=new Date();
        long time=date.getTime();
         String result = "";
      Random random = new Random();
          for (int i = 0; i < 5; i++) {
         result += random.nextInt(10);
   }
      return time + result;
   }

//    public static void main(String[] args) {
//        System.out.println(ordertime.getOrderIdByTime());
//        System.out.println(new Date());
//    }
}
