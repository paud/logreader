/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mak.ui;

import javax.swing.ImageIcon;
import mak.capture.log.MainWndOutput;
import mak.capture.log.OutPutMgr;
import mak.capture.log.Output;
import mak.capture.log.OutputTypes;
import mak.tools.StringUtil;

/**
 *
 * @author Chin
 */
public class Frm_Main extends javax.swing.JFrame {
    
    /**
     *
     */
    private static final long serialVersionUID = -8473221171486904564L;
    private static final Frm_Main instance = new Frm_Main();
    /**
     * Creates new form Frm_Main
     */
    public Frm_Main() {
        initComponents();
    }

    public static Frm_Main getInstance() {
        return instance;
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jMenu3 = new javax.swing.JMenu();
        jMenu4 = new javax.swing.JMenu();
        jMenuBar2 = new javax.swing.JMenuBar();
        jMenu6 = new javax.swing.JMenu();
        jMenu7 = new javax.swing.JMenu();
        jMenuItem2 = new javax.swing.JMenuItem();
        jToolBar1 = new javax.swing.JToolBar();
        btn_new = new javax.swing.JButton();
        btn_start = new javax.swing.JButton();
        btn_stop = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jScrollPane2 = new javax.swing.JScrollPane();
        logwnd = new javax.swing.JTextPane();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        jMenu2 = new javax.swing.JMenu();
        jMenu5 = new javax.swing.JMenu();

        jMenu3.setText("jMenu3");

        jMenu4.setText("jMenu4");

        jMenu6.setText("File");
        jMenuBar2.add(jMenu6);

        jMenu7.setText("Edit");
        jMenuBar2.add(jMenu7);

        jMenuItem2.setText("jMenuItem2");

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setLocationByPlatform(true);

        jToolBar1.setFloatable(false);
        jToolBar1.setRollover(true);
        jToolBar1.setMaximumSize(new java.awt.Dimension(130, 44));
        jToolBar1.setMinimumSize(new java.awt.Dimension(130, 44));
        jToolBar1.setPreferredSize(new java.awt.Dimension(130, 44));

        btn_new.setText("����");
        btn_new.setFocusable(false);
        btn_new.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        btn_new.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        btn_new.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_newActionPerformed(evt);
            }
        });
        jToolBar1.add(btn_new);

        btn_start.setIcon(new javax.swing.ImageIcon(getClass().getResource("/mak/res/run_16.png"))); // NOI18N
        btn_start.setText("��ʼ");
        btn_start.setFocusable(false);
        btn_start.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        btn_start.setMaximumSize(new java.awt.Dimension(40, 41));
        btn_start.setMinimumSize(new java.awt.Dimension(40, 41));
        btn_start.setPreferredSize(new java.awt.Dimension(40, 41));
        btn_start.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        btn_start.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_startActionPerformed(evt);
            }
        });
        jToolBar1.add(btn_start);

        btn_stop.setIcon(new javax.swing.ImageIcon(getClass().getResource("/mak/res/stop_16.png"))); // NOI18N
        btn_stop.setText("ֹͣ");
        btn_stop.setToolTipText("");
        btn_stop.setEnabled(false);
        btn_stop.setFocusable(false);
        btn_stop.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        btn_stop.setMaximumSize(new java.awt.Dimension(40, 41));
        btn_stop.setMinimumSize(new java.awt.Dimension(40, 41));
        btn_stop.setPreferredSize(new java.awt.Dimension(40, 41));
        btn_stop.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        btn_stop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_stopActionPerformed(evt);
            }
        });
        jToolBar1.add(btn_stop);

        jButton1.setText("RefreshList");
        jButton1.setFocusable(false);
        jButton1.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton1.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton1);

        jButton2.setText("SaveCfg");
        jButton2.setFocusable(false);
        jButton2.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton2.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton2);

        jButton3.setText("LoadCfg");
        jButton3.setFocusable(false);
        jButton3.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton3.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton3);

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "״̬", "����", "������ʼ��", "Title 4"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.Object.class
            };
            boolean[] canEdit = new boolean [] {
                false, false, false, false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jTable1.setRowHeight(18);
        jTable1.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane1.setViewportView(jTable1);

        logwnd.setFont(new java.awt.Font("����", 0, 14)); // NOI18N
        jScrollPane2.setViewportView(logwnd);
        logwnd.getAccessibleContext().setAccessibleName("");

        jMenu1.setText("File");

        jMenuItem1.setText("jMenuItem1");
        jMenu1.add(jMenuItem1);

        jMenuBar1.add(jMenu1);

        jMenu2.setText("Edit");
        jMenuBar1.add(jMenu2);

        jMenu5.setText("jMenu5");
        jMenuBar1.add(jMenu5);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 746, Short.MAX_VALUE)
            .addComponent(jToolBar1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToolBar1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 219, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 374, Short.MAX_VALUE))
        );

        pack();
        setLocationRelativeTo(null);
    }// </editor-fold>//GEN-END:initComponents

    private Object[][] getModelData() {
//        Object [][]  res = new Object [][] {
//                {1, 2, 3, 4},
//                {'a', "b", "c", "d"},
//            };
        Object[][] res = new Object[JobMgr.getInstance().JobList().size()][4];
        for (int i = 0; i < JobMgr.getInstance().JobList().size(); i++) {
            Job job = JobMgr.getInstance().JobList().get(i);
            res[i][0] = job.state.ordinal();

            String cfgStr = StringUtil.getXmlValueFromStr(job.aJobStr, ConstString.cfgTagName);
            res[i][1] = StringUtil.getXmlValueFromStr(cfgStr, ConstString.JobName);
            res[i][2] = StringUtil.getXmlValueFromStr(cfgStr, ConstString.StartTime);
        }
        return res;
    }

    public void SetTableViewData() {
        jTable1.setModel(new javax.swing.table.DefaultTableModel(
                getModelData(),
                new String[]{
                    "״̬", "����", "������ʼ��", "Title 4"
                }
        ) {
            Class[] types = new Class[]{
                ImageIcon.class, java.lang.String.class, java.lang.String.class, java.lang.Object.class
            };
            boolean[] canEdit = new boolean[]{
                false, false, false, false
            };

            @Override
            public Class getColumnClass(int columnIndex) {
                return types[columnIndex];
            }

            @Override
            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit[columnIndex];
            }

            @Override
            public Object getValueAt(int rowidx, int colIdx) {
                if (colIdx == 0) {
                    int state = (int) super.getValueAt(rowidx, colIdx);
                    JobState js = JobState.values()[state];
                    ImageIcon ii = null;
                    switch (js) {
                        case Uninitialized:
                            ii = new ImageIcon(Frm_Main.class.getResource("../res/exclamation.png"));
                            break;
                        case Stoped:
                            ii = new ImageIcon(Frm_Main.class.getResource("../res/stop_16.png"));
                            break;
                        case Running:
                            ii = new ImageIcon(Frm_Main.class.getResource("../res/tick.png"));
                            break;
                        case Error:
                            ii = new ImageIcon(Frm_Main.class.getResource("../res/cross_octagon.png"));
                            break;
                    }
                    return ii;
                } else {
                    return super.getValueAt(rowidx, colIdx);
                }
            }
        });
    }

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        SetTableViewData();
    }//GEN-LAST:event_jButton1ActionPerformed

    private void btn_startActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_startActionPerformed
        btn_start.setEnabled(false);
        btn_stop.setEnabled(true);
        
               
        JobMgr.getInstance().Start(jTable1.getSelectedRow());
    }//GEN-LAST:event_btn_startActionPerformed

    private void btn_stopActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_stopActionPerformed
        btn_start.setEnabled(true);
        btn_stop.setEnabled(false);
    }//GEN-LAST:event_btn_stopActionPerformed

    private void btn_newActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_newActionPerformed
        Frm_AddJob fAddJob = new Frm_AddJob();
        fAddJob.setModal(true);
        fAddJob.setVisible(true);

        if (fAddJob.ModalResult == 1) {
            JobMgr.getInstance().CreateNewJob(fAddJob.ConStrSrc, fAddJob.ConStrDst, fAddJob.CfgStr);
            SetTableViewData();
        }
    }//GEN-LAST:event_btn_newActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        JobMgr.getInstance().saveToCfg();
        MainWndOutput.getInstance().Info("���������ļ��ɹ���");
        SetTableViewData();
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        JobMgr.getInstance().loadFromCfg();
        MainWndOutput.getInstance().Info("���������ļ��ɹ���");
        SetTableViewData();
    }//GEN-LAST:event_jButton3ActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(Frm_Main.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Frm_Main.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Frm_Main.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Frm_Main.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
                instance.setVisible(true);
            }
        });

        new OutPutMgr(OutputTypes.MainWnd, OutputTypes.Console).Error("dddddddddddddddddddd");
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btn_new;
    private javax.swing.JButton btn_start;
    private javax.swing.JButton btn_stop;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenu jMenu3;
    private javax.swing.JMenu jMenu4;
    private javax.swing.JMenu jMenu5;
    private javax.swing.JMenu jMenu6;
    private javax.swing.JMenu jMenu7;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JMenuBar jMenuBar2;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTable jTable1;
    private javax.swing.JToolBar jToolBar1;
    public javax.swing.JTextPane logwnd;
    // End of variables declaration//GEN-END:variables
}