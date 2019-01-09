import java.awt.*;
import java.awt.event.KeyEvent;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.security.Key;
import java.util.ArrayList;

public class MyRobot {
    private static ArrayList<Integer>pressingKeys = new ArrayList<>();

    private static int toKey(String str){
        if(str.length() == 1) {
            char ch = str.charAt(0);
            if (ch >= 0x30 && ch <= 0x39)
                return ch;
            if (ch >= 0x40 && ch <= 0x5a)
                return ch;
            if (ch >= 0x61 && ch <= 0x7a)
                return ch - 0x20;
        }
        switch (str){
            case "delete": return KeyEvent.VK_BACK_SPACE;
            case "shift": return KeyEvent.VK_SHIFT;
            case "enter": return KeyEvent.VK_ENTER;
            case "tab": return KeyEvent.VK_TAB;
            case "caps": return KeyEvent.VK_CAPS_LOCK;
            case "space": return KeyEvent.VK_SPACE;
            case "ctrl": return KeyEvent.VK_CONTROL;
            case "alt": return KeyEvent.VK_ALT;
            case "left": return KeyEvent.VK_LEFT;
            case "right": return KeyEvent.VK_RIGHT;
            case "down": return KeyEvent.VK_DOWN;
            case "up": return KeyEvent.VK_UP;
            case "super": return KeyEvent.VK_WINDOWS;
            case "`": return KeyEvent.VK_PERIOD;
            case "-": return '-';
            case "=": return '=';
            case ",": return ',';
            case ".": return '.';
            case "/": return '/';
            case ";": return ';';
            case "[": return '[';
            case "]": return ']';
            case "\\": return '\\';
        }
        return KeyEvent.VK_ENTER;
    }

    private static boolean keyPress(Robot robot, int key){
        if(pressingKeys.contains(key)){
            int index = pressingKeys.indexOf(key);
            pressingKeys.remove(index);
            return true;
        }
        else {
            switch(key){
                case KeyEvent.VK_CONTROL: pressingKeys.add(key); robot.keyPress(key); return false;
                case KeyEvent.VK_SHIFT: pressingKeys.add(key); robot.keyPress(key); return false;
                case KeyEvent.VK_ALT: pressingKeys.add(key); robot.keyPress(key); return false;
                case KeyEvent.VK_CAPS_LOCK: pressingKeys.add(key); robot.keyPress(key); return false;
                case KeyEvent.VK_WINDOWS: pressingKeys.add(key); robot.keyPress(key); return false;
                default: robot.keyPress(key); return true;
            }
        }
    }

    private static void keyRelease(Robot robot, int key){
        robot.keyRelease(key);
    }

    public static void main(String[] args) {
        try{
            Robot robot = new Robot();
            robot.waitForIdle();
            ServerSocket serverSocket = new ServerSocket(7777);
            while(true){
                Socket server = serverSocket.accept();
                BufferedReader buf = new BufferedReader(new InputStreamReader(server.getInputStream()));
                //char ch = buf.readLine().charAt(0);
                String str = buf.readLine();
                if(str == null) continue;
                int key = toKey(str);
                if(keyPress(robot, key))
                    keyRelease(robot, key);
                robot.delay(100);
            }
        }catch (Exception ex){
            ex.printStackTrace();
        }

    }
}
