package com.calculator.aa.ui;

import com.calculator.aa.Main;
import com.calculator.aa.calc.Calc;
import com.calculator.aa.db.InstrumentsMeta;

import javax.swing.*;
import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.*;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class FilterDB extends JDialog {
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;
    private JButton buttonFilter;
    private JButton buttonClearFilter;
    private JList<String> listInstrumentTypes;
    private JList<String> listInstrumentProviders;
    private JSpinner spinnerMinHistory;
    private JList<String> listResults;
    private JTextField nameTextField;
    private JList<String> listSelected;
    private JButton buttonRemoveSelected;
    private JButton buttonAddSelected;

    private final InstrumentsMeta meta;
    private AATableModel result;
    private boolean isAborted;
    private List<String> filteredTickets;
    private List<String> selectedTickets;

    private FilterDB(String[] instr) {
        setContentPane(contentPane);
        setModal(true);
        getRootPane().setDefaultButton(buttonFilter);

        result = null;
        meta = new InstrumentsMeta("db/meta/db_instruments.csv");
        selectedTickets = new ArrayList<>();

        meta.getNames(Arrays.asList(instr)).keySet().forEach(selectedTickets::add);

        prepareLists();

        buttonOK.addActionListener(e -> onOK());

        buttonCancel.addActionListener(e -> onCancel());

        // call onCancel() when cross is clicked
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                onCancel();
            }
        });

        // call onCancel() on ESCAPE
        contentPane.registerKeyboardAction(e -> onCancel(),
                KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);

        spinnerMinHistory.addMouseWheelListener(new SpinnerWheelListener(spinnerMinHistory));

        buttonClearFilter.addActionListener(actionEvent -> {
            listInstrumentTypes.setSelectedIndex(0);
            listInstrumentProviders.setSelectedIndex(0);
            spinnerMinHistory.setValue(0);
            nameTextField.setText("");
            listResults.setModel(new DefaultListModel<>());
        });
        buttonFilter.addActionListener(actionEvent -> {
            int[] selectedTypes = listInstrumentTypes.getSelectedIndices();
            int[] selectedProviders = listInstrumentProviders.getSelectedIndices();

            Stream<List<String>> filteredTypes = null;
            if (!containsAllFilter(selectedTypes)) {
                for (int i: selectedTypes) {
                    if (filteredTypes == null) {
                        filteredTypes = meta.filterByType(listInstrumentTypes.getModel().getElementAt(i));
                    } else {
                        filteredTypes = Stream.concat(filteredTypes, meta.filterByType(listInstrumentTypes.getModel().getElementAt(i)));
                    }
                }
            } else {
                filteredTypes = meta.unfiltered();
            }
            List<List<String>> filteredTypesList = filteredTypes != null ?
                    filteredTypes.collect(Collectors.toList()) :
                    new LinkedList<>();

            Stream<List<String>> filteredProviders = null;
            if (!containsAllFilter(selectedProviders)) {
                for (int i: selectedProviders) {
                    if (filteredProviders == null) {
                        filteredProviders = meta.filterByProvider(listInstrumentProviders.getModel().getElementAt(i));
                    } else {
                        filteredProviders = Stream.concat(filteredProviders, meta.filterByProvider(listInstrumentProviders.getModel().getElementAt(i)));
                    }
                }
            } else {
                filteredProviders = meta.unfiltered();
            }
            List<List<String>> filteredProvidersList = filteredProviders != null ?
                    filteredProviders.collect(Collectors.toList()) :
                    new LinkedList<>();

            Stream<List<String>> filteredDates;
            int minMonths = (int)spinnerMinHistory.getModel().getValue();
            if (minMonths > 0) {
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.MONTH, -minMonths);
                filteredDates = meta.filterByDate(cal.getTime());
            } else {
                filteredDates = meta.unfiltered();
            }
            List<List<String>> filteredDatesList = filteredDates.collect(Collectors.toList());

            Stream<List<String>> filteredNames;
            String textNames = nameTextField.getText();
            if (!textNames.isEmpty()) {
                filteredNames = meta.filterByText(textNames);
            } else {
                filteredNames = meta.unfiltered();
            }
            List<List<String>> filteredNamesList = filteredNames.collect(Collectors.toList());

            Stream<List<String>> allFiltered = filteredTypesList.stream()
                    .filter(filteredProvidersList::contains)
                    .filter(filteredDatesList::contains)
                    .filter(filteredNamesList::contains);

            SortedMap<String, String> resultNames = new TreeMap<>(meta.getNames(allFiltered));
            DefaultListModel<String> resultModel = new DefaultListModel<>();
            filteredTickets = new LinkedList<>();
            resultNames.forEach((k, v) -> {
                filteredTickets.add(k);
                resultModel.addElement(this.formatName(k, v));
            });
            listResults.setModel(resultModel);
        });

        buttonAddSelected.addActionListener(actionEvent -> {
            int[] selectedIndexes = listResults.getSelectedIndices();
            if (selectedIndexes == null || selectedIndexes.length == 0) {
                return;
            }

            List<String> results = Arrays.stream(selectedIndexes)
                    .boxed()
                    .map(filteredTickets::get)
                    .collect(Collectors.toList());

            DefaultListModel<String> newModel = new DefaultListModel<>();
            List<String> newSelected = Stream.concat(
                    results.stream().filter(r -> !selectedTickets.contains(r)),
                    selectedTickets.stream()
            ).collect(Collectors.toList());

            SortedMap<String, String> newNames = new TreeMap<>(meta.getNames(newSelected));
            selectedTickets = new ArrayList<>(newNames.size());
            newNames.forEach((k, v) -> {
                selectedTickets.add(k);
                newModel.addElement(this.formatName(k, v));
            });
            listSelected.setModel(newModel);
        });
        buttonRemoveSelected.addActionListener(actionEvent -> {
            int[] selectedIndexes = listSelected.getSelectedIndices();
            if (selectedIndexes == null || selectedIndexes.length == 0) {
                return;
            }
            List<String> selected = Arrays.stream(selectedIndexes)
                    .boxed()
                    .map(selectedTickets::get)
                    .collect(Collectors.toList());

            List<String> restTickets = selectedTickets.stream().filter(t -> !selected.contains(t)).collect(Collectors.toList());
            DefaultListModel<String> newModel = new DefaultListModel<>();
            SortedMap<String, String> newNames = new TreeMap<>(meta.getNames(restTickets));
            selectedTickets = new ArrayList<>(newNames.size());
            newNames.forEach((k, v) -> {
                selectedTickets.add(k);
                newModel.addElement(this.formatName(k, v));
            });
            listSelected.setModel(newModel);

        });
    }

    private void prepareLists() {
        DefaultListModel<String> types = new DefaultListModel<>();
        types.addElement(Main.resourceBundle.getString("text.all"));
        meta.getTypes().forEach(types::addElement);
        listInstrumentTypes.setModel(types);
        listInstrumentTypes.setSelectedIndex(0);

        DefaultListModel<String> providers = new DefaultListModel<>();
        providers.addElement(Main.resourceBundle.getString("text.all"));
        meta.getProviders().keySet().forEach(providers::addElement);
        listInstrumentProviders.setModel(providers);
        listInstrumentProviders.setSelectedIndex(0);

        DefaultListModel<String> selected = new DefaultListModel<>();
        SortedMap<String, String> selectedNames = new TreeMap<>(meta.getNames(selectedTickets));
        selectedNames.forEach((k, v) -> selected.addElement(this.formatName(k, v)));
        listSelected.setModel(selected);
    }

    private String formatName(String ticker, String descr) {
        return ticker + " (" + descr + ")";
    }

    private void onOK() {
        if (selectedTickets.size() > 0) {
            result = ConvertOptions.showOptions(selectedTickets.toArray(new String[0]), meta);
        }
        isAborted = false;
        if (result != null) {

            Rectangle bounds = getBounds();
            Main.properties.setProperty("filter.x", String.valueOf((int)bounds.getX()));
            Main.properties.setProperty("filter.y", String.valueOf((int)bounds.getY()));
            Main.properties.setProperty("filter.w", String.valueOf((int)bounds.getWidth()));
            Main.properties.setProperty("filter.h", String.valueOf((int)bounds.getHeight()));

            dispose();
        }
    }

    private void onCancel() {
        result = null;
        isAborted = true;
        Rectangle bounds = getBounds();
        Main.properties.setProperty("filter.x", String.valueOf((int)bounds.getX()));
        Main.properties.setProperty("filter.y", String.valueOf((int)bounds.getY()));
        Main.properties.setProperty("filter.w", String.valueOf((int)bounds.getWidth()));
        Main.properties.setProperty("filter.h", String.valueOf((int)bounds.getHeight()));
        dispose();
    }

    private void createUIComponents() {
        listInstrumentTypes = new JList<>();
        listInstrumentProviders = new JList<>();
        listResults = new JList<>();
        listSelected = new JList<>();

        spinnerMinHistory = new JSpinner(new SpinnerNumberModel(0, 0, 10000, 1));
    }

    private boolean containsAllFilter(int[] array) {
        for (int i: array) {
            if (i == 0) {
                return true;
            }
        }
        return false;
    }

    static AATableModel showFilter(String[] instr) {
        FilterDB dialog = new FilterDB(instr);
        dialog.setTitle(Main.resourceBundle.getString("text.filter_db"));
        dialog.setLocationRelativeTo(Main.getFrame());

        dialog.pack();

        int x = Calc.safeParseInt(Main.properties.getProperty("filter.x", "-1"), -1);
        int y = Calc.safeParseInt(Main.properties.getProperty("filter.y", "-1"), -1);
        int w = Calc.safeParseInt(Main.properties.getProperty("filter.w", "-1"), -1);
        int h = Calc.safeParseInt(Main.properties.getProperty("filter.h", "-1"), -1);

        if (x >= 0 && y >= 0 && w >= 0 && h >= 0) {
            Rectangle rec = new Rectangle(x, y, w, h);
            dialog.setBounds(rec);
        }

        while (dialog.result == null) {
            dialog.setVisible(true);
            if (dialog.isAborted) {
                return null;
            }
        }

        return dialog.result;
    }
}
