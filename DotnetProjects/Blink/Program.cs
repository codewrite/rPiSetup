using System;
using System.Threading;
using System.Device.Gpio;

namespace Blink
{
    class Program
    {
        private const int LedPin = 0;      // Set this to the GPIO pin with an LED on it, e.g. LedPin = 17;

        static void Main(string[] args)
        {
            Console.WriteLine("Blink an LED." + ((LedPin != 0) ? $" The LED has to be on pin {LedPin}" : ""));

#pragma warning disable CS0162
            // This is just for this demonstration. In production code there would be no need for this check
            if (LedPin == 0)
            {
                Console.WriteLine($"Edit the code, change LedPin to an actual GPIO pin with an LED on it");
                Environment.Exit(1);
            }
#pragma warning restore CS0162

            var controller = new GpioController();
        
            controller.OpenPin(LedPin, PinMode.Output);

            while (true)
            {
                controller.Write(LedPin, PinValue.High);
                Thread.Sleep(500);
                controller.Write(LedPin, PinValue.Low);
                Thread.Sleep(500);
            }
        }
    }
}
