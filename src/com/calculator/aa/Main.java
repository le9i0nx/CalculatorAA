package com.calculator.aa;

import com.calculator.aa.ui.MainWindow;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.*;
import java.nio.file.Files;
import java.util.Properties;

public class Main {
    private static Main program;
    private final JFrame mainFrame;
    private final MainWindow mainWindow;
    private final Properties properties;
    private static final String propertiesFile = "calcaa.properties";

    private Main() {

        properties = new Properties();
        try {
            if (Files.exists(new File(propertiesFile).toPath())) {
                properties.load(new BufferedInputStream(new FileInputStream(propertiesFile)));
            }
        } catch (IOException e) {}

        mainFrame = new JFrame("СПТ: калькулятор");
        mainWindow = new MainWindow();
        mainFrame.setContentPane(mainWindow.GetMainPanel());
        mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        mainFrame.setLocationRelativeTo(null);

        mainFrame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        mainFrame.addWindowListener( new WindowAdapter() {
            public void windowClosing(WindowEvent we) {
                try {
                    Rectangle bounds = mainFrame.getBounds();
                    properties.setProperty("frame.x", String.valueOf((int)bounds.getX()));
                    properties.setProperty("frame.y", String.valueOf((int)bounds.getY()));
                    properties.setProperty("frame.w", String.valueOf((int)bounds.getWidth()));
                    properties.setProperty("frame.h", String.valueOf((int)bounds.getHeight()));

                    int maximized = (mainFrame.getExtendedState() & JFrame.MAXIMIZED_BOTH) > 0 ? 1 : 0;
                    properties.setProperty("frame.z", String.valueOf(maximized));

                    properties.store(new BufferedOutputStream(new FileOutputStream(propertiesFile)), "CalculatorAA");

                } catch(Exception e) {}
                System.exit(0);
            }
        });

        mainFrame.pack();

        int x = Integer.parseInt(properties.getProperty("frame.x", "-1"));
        int y = Integer.parseInt(properties.getProperty("frame.y", "-1"));
        int w = Integer.parseInt(properties.getProperty("frame.w", "-1"));
        int h = Integer.parseInt(properties.getProperty("frame.h", "-1"));
        int z = Integer.parseInt(properties.getProperty("frame.z", "0"));

        if (z == 1) {
            mainFrame.setExtendedState(mainFrame.getExtendedState() | JFrame.MAXIMIZED_BOTH);
        } else if (x >= 0 && y >= 0 && w >= 0 && h >= 0) {
            Rectangle rec = new Rectangle(x, y, w, h);
            mainFrame.setBounds(rec);
        }

        mainFrame.setVisible(true);
    }

    public static JFrame getFrame() {
        return program.mainFrame;
    }

    public static Properties getProperties() {
        return program.properties;
    }

    public static void main(String[] args) {
        program = new Main();
    }
}
