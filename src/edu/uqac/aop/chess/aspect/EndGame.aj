package edu.uqac.aop.chess.aspect;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.*;
import edu.uqac.aop.chess.piece.*;
import edu.uqac.aop.chess.tool.Pair;

public aspect EndGame {

	pointcut endGame():
		call (Move Player.makeMove())
		&& target(Player);

	after() returning (Move mv):
		endGame(){
		Player p = (Player) thisJoinPoint.getTarget();
		Board b = p.getPlayGround();
		checkEndGame(b, mv, p);

	}

	/**
	 * Vérifie s'il y a "echec" ou "echec et mat"
	 * @param b : tableau d'échec
	 * @param mv : dernier mouvement appliqué
	 * @param p : joueur qui a joué le dernier coup
	 */
	protected void checkEndGame(Board b, Move mv, Player p) {
		// Piece pi = b.getGrid()[mv.xI][mv.yI].getPiece();
		System.out.println("Joli Coup");
		if (check(b, Player.WHITE)) {
			if (p.getColor() == Player.WHITE) {
				System.out.println("Mauvais Coup, Il faut rejouer joueur Noir");
				replay(mv, p, b);
			} else {
				System.out.println("ECHEC au Joueur Blanc !");
				if (testCheckAndMat(b, Player.BLACK)) {
					b.print();
					System.out.println("ECHEC ET MAT ! Le Joueur Noir a gagné !!!");
					System.exit(0);
				}
			}
		} else if (check(b, Player.BLACK)) {
			if (p.getColor() == Player.BLACK) {
				System.out.println("Mauvais Coup, Il faut rejouer joueur Blanc");
				replay(mv, p, b);
			} else {
				System.out.println("ECHEC au Joueur Noir !");
				if (testCheckAndMat(b, Player.WHITE)) {
					b.print();
					System.out.println("ECHEC ET MAT ! Le Joueur Blanc a gagné !!!");
					System.exit(0);
				}

			}
		}
	}

	/**
	 * Verifie s'il y a "échec"
	 * @param b : tableau d'échec
	 * @param playerColor : le joueur qui veut faire "échec"
	 * @return vrai si il y a échec
	 */
	private boolean check(Board b, int playerColor) {
		int player;
		int opponent;
		Piece king = null;
		if (playerColor == Player.WHITE) {
			player = Player.WHITE;
			opponent = Player.BLACK;
		} else {
			player = Player.BLACK;
			opponent = Player.WHITE;
		}
		Map<Piece, Pair<Integer, Integer>> pieces = new HashMap<Piece, Pair<Integer, Integer>>();

		int kingX = 0;
		int kingY = 0;
		for (int x = 0; x < Board.SIZE; x++) {
			for (int y = 0; y < Board.SIZE; y++) {
				Spot s = b.getGrid()[x][y];
				if (s.isOccupied()) {
					if (s.getPiece().getPlayer() == player) {
						pieces.put(s.getPiece(), new Pair<Integer, Integer>(x, y));
					} else if (s.getPiece().getPlayer() == opponent && s.getPiece() instanceof King) {
						king = s.getPiece();
						kingX = x;
						kingY = y;

					}
				}
			}

		}

		for (Map.Entry<Piece, Pair<Integer, Integer>> entry : pieces.entrySet()) {
			Move m = new Move(entry.getValue().getLeft(), entry.getValue().getRight(), kingX, kingY);
			if (entry.getKey().isMoveLegal(m) && CheckMove.checkMove(b, m) == true) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Rejoue le dernier coup si le mouvement d'un joueur le met en échec
	 * @param mv : dernier mouvement appliqué
	 * @param p : Le joueur qui s'est mis en échec
	 * @param b : le tableau d'échec
	 */
	private void replay(Move mv, Player p, Board b) {
		b.movePiece(new Move(mv.xF, mv.yF, mv.xI, mv.yI));
		System.out.println(p.getColor());
		p.makeMove();
	}

	/**
	 * Test si il y a "échec et mat"
	 * @param b : le tableau d'échec
	 * @param playerColor : la couleur du joueur qui subit l'échec
	 * @return vrai si il y a "échec et mat"
	 */
	private boolean testCheckAndMat(Board b, int playerColor) {
		int KingX = 0;
		int KingY = 0;
		Piece king = null;
		int opponentColor = Player.BLACK;
		if (playerColor == Player.BLACK) {
			opponentColor = Player.WHITE;
		}
		for (int x = 0; x < Board.SIZE; x++) {
			for (int y = 0; y < Board.SIZE; y++) {
				Spot s = b.getGrid()[x][y];
				if (s.isOccupied()) {
					if (s.getPiece() instanceof King && s.getPiece().getPlayer() == playerColor) {
						KingX = x;
						KingY = y;
						king = s.getPiece();
						List<Move> movesToEvaluate = new ArrayList<Move>();
						if (KingX > 0) {
							movesToEvaluate.add(new Move(KingX, KingY, KingX - 1, KingY));
							if (KingY > 0) {
								movesToEvaluate.add(new Move(KingX, KingY, KingX - 1, KingY - 1));
							}
							if (KingY < Board.SIZE - 1) {
								movesToEvaluate.add(new Move(KingX, KingY, KingX - 1, KingY + 1));
							}
						}
						if (KingX < Board.SIZE - 1) {
							movesToEvaluate.add(new Move(KingX, KingY, KingX + 1, KingY));
							if (KingY > 0) {
								movesToEvaluate.add(new Move(KingX, KingY, KingX + 1, KingY - 1));
							}
							if (KingY < Board.SIZE - 1) {
								movesToEvaluate.add(new Move(KingX, KingY, KingX + 1, KingY + 1));
							}
						}
						if (KingY > 0) {
							movesToEvaluate.add(new Move(KingX, KingY, KingX, KingY - 1));
						}

						if (KingY < Board.SIZE - 1) {
							movesToEvaluate.add(new Move(KingX, KingY, KingX, KingY + 1));
						}
						return !testMovesToUncheck(king, movesToEvaluate, b, opponentColor);
					}
				}
			}
		}
		return true;
	}

	/**
	 * Test si le roi peut se sortir de l'échec
	 * @param king : le roi mis en échec
	 * @param movesToEvaluate : une liste de mouvements pouvant être appliqués par le roi
	 * @param b : le tableau du jeu d'échec
	 * @param opponentColor : La couleur du joueur adverse qui a mis en échec le roi
	 * @return vrai si le roi peut se sortir de l'échec, faux si il y a échec et mat
	 */
	private boolean testMovesToUncheck(Piece king, List<Move> movesToEvaluate, Board b, int opponentColor) {
		for (Move m : movesToEvaluate) {
			if (king.isMoveLegal(m) && CheckMove.checkMove(b, m) == true) {
				Piece pieceToRemake = null;
				if (b.getGrid()[m.xF][m.yF].isOccupied()) {
					pieceToRemake = b.getGrid()[m.xF][m.yF].getPiece();
				}
				b.movePiece(m);
				if (!check(b, opponentColor)) {
					Move moveToReturn = new Move(m.xF, m.yF, m.xI, m.yI);
					b.movePiece(moveToReturn);
					if (pieceToRemake != null) {
						b.getGrid()[m.xF][m.yF].setPiece(pieceToRemake);
					}
					return true;
				}
				Move moveToReturn = new Move(m.xF, m.yF, m.xI, m.yI);
				b.movePiece(moveToReturn);
				if (pieceToRemake != null) {
					b.getGrid()[m.xF][m.yF].setPiece(pieceToRemake);
				}
			}
		}

		return false;
	}
}
