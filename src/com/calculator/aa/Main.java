package com.calculator.aa;

import com.calculator.aa.ui.MainWindow;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.stream.Stream;

public class Main {
    private static Main program;
    private final JFrame mainFrame;
    private final MainWindow mainWindow;
    private final Properties properties;
    private static final String propertiesFile = "calcaa.properties";

    public static ResourceBundle resourceBundle;
    public static Cursor voidCursor;

    private Main(Properties props) {

        properties = props;

        mainFrame = new JFrame(resourceBundle.getString("text.program_name"));
        mainWindow = new MainWindow();
        mainFrame.setContentPane(mainWindow.GetMainPanel());
        mainFrame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
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

                } catch(Exception ignored) {}
                System.exit(0);
            }
        });

        restoreFrameProperties();

        mainFrame.setVisible(true);
    }

    public static Main getMain() {
        return program;
    }

    public static JFrame getFrame() {
        return program.mainFrame;
    }

    public static Properties getProperties() {
        return program.properties;
    }

    public void restoreFrameProperties() {
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
    }

    public static String[] getPeriods(int fromIndex, int toIndex) {
        String[] periods = program.mainWindow.getPeriods();
        int max = Math.min(toIndex, periods.length - 1) + 1;
        return Arrays.copyOfRange(periods, fromIndex, max);
    }

    public static void main(String[] args) {
        resourceBundle = ResourceBundle.getBundle("com.calculator.aa.messages", Locale.getDefault());

        voidCursor = Toolkit.getDefaultToolkit().createCustomCursor(
                new BufferedImage(3, 3, BufferedImage.TYPE_INT_ARGB),
                new Point(0, 0),
                "null");

        Properties prop = new Properties();
        try {
            if (Files.exists(new File(propertiesFile).toPath())) {
                prop.load(new BufferedInputStream(new FileInputStream(propertiesFile)));
            }
        } catch (IOException ignored) {}

        String laf = prop.getProperty("ui.theme");
        if (laf != null) {
            try {
                UIManager.setLookAndFeel(laf);
            } catch (Exception ignored) {}
        }

        String[] savedOptions = new String[] {";", "\"", ".", "1"};

        String s = prop.getProperty("import.delimiter");
        if (s != null) {
            savedOptions[0] = s;
        }

        s = prop.getProperty("import.mark");
        if (s != null) {
            savedOptions[1] = s;
        }

        s = prop.getProperty("import.decimal");
        if (s != null) {
            savedOptions[2] = s;
        }

        s = prop.getProperty("import.date");
        if (s != null) {
            savedOptions[3] = s;
        }

        SwingUtilities.invokeLater(() -> {
            program = new Main(prop);

            String file = program.properties.getProperty("files.last", "");
            if (!file.isEmpty()) {
                SwingUtilities.invokeLater(() -> {
                    String[] files = file.split(";");
                    if (files.length > 0) {
                        program.mainWindow.parseCSVAndLoadData(new File(files[0]), savedOptions);
                    }
                    Stream.of(Arrays.copyOfRange(files, 1, files.length)).map(File::new).forEach(program.mainWindow::silentParseCSVAndMergeData);
                });
            }
        });
    }
}
