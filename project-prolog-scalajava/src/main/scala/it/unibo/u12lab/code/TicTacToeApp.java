package it.unibo.u12lab.code;

import javax.swing.*;
import java.awt.*;

/** A not so nicely engineered App to run TTT games, not very important.
 * It just works..
 */
public class TicTacToeApp {

    final TicTacToe ttt;
    final JButton[][] board = new JButton[3][3];
    final JButton exit = new JButton("Exit");
    final JFrame frame = new JFrame("TTT");
    boolean finished = false;

    public TicTacToeApp(TicTacToe ttt) throws Exception {
        this.ttt=ttt;
        initPane();
    }
    
    private void humanMove(int i, int j){
        if (ttt.isAFreeCell(i,j)){
            board[i][j].setText("X");
            ttt.setHumanCell(i,j);
        }
        if (ttt.checkVictory()){
            exit.setText("Won!");
            finished=true;
            return;
        }
        if (ttt.checkCompleted()){
            exit.setText("Even!");
            finished=true;
            return;
        }
        computerMove();
    }
    
    private void computerMove(){
        int[] i=ttt.setComputerCell();
        board[i[0]][i[1]].setText("O");
        if (ttt.checkVictory()){
            exit.setText("Lost!");
            finished=true;
        }
    }
    
    private void initPane(){
        frame.setLayout(new BorderLayout());
        JPanel b=new JPanel(new GridLayout(3,3));
        for (int i=0;i<3;i++){
            for (int j=0;j<3;j++){
                final int i2 = i;
                final int j2 = j;
                board[i][j]=new JButton("");
                b.add(board[i][j]);
                board[i][j].addActionListener(e -> { if (!finished) humanMove(i2,j2); });
            }
        }
        JPanel s=new JPanel(new FlowLayout());
        s.add(exit);
        exit.addActionListener(e -> System.exit(0));
        frame.add(BorderLayout.CENTER,b);
        frame.add(BorderLayout.SOUTH,s);
        frame.setSize(200,230);
        frame.setVisible(true);
    }

    public static void main(String[] args){
        try {
            // should probably adjust the folder down here
            new TicTacToeApp(new TicTacToeImpl("/ttt.pl"));
        } catch (Exception e) {
            System.out.println("Problems loading the theory");
        }
    }
}
