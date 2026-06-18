package ch.sbs.liblouis.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Copyright (C) 2010 Swiss Library for the Blind, Visually Impaired and Print
 * Disabled
 * 
 * This file is part of dtbook2sbsform.
 * 
 * dtbook2sbsform is free software: you can redistribute it
 * and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program. If not, see
 * <http://www.gnu.org/licenses/>.
 */

public class LineBreaker {

	private static final int STD_WIDTH = 80;
	private static final int HEAD_WIDTH = 120;
	private static final java.util.regex.Pattern HEADING_LINE =
		java.util.regex.Pattern.compile("y H[1-6].*");

	/**
	 * Simplistic left-alignment formatting of text. Lines are wrapped at
	 * whitespaces. If a sequence of non-whitespaces exceeds the desired width,
	 * the resulting line will simply be too long. Consecutive whitespaces will
	 * be condensed into a single blank.
	 * formatSbs-variant throws a RuntimeException when a newline is encountered
	 * within the string, since this is not supported.
	 * 
	 * This could have been implemented as a perl one-liner. But since we might
	 * move this functionality into the pipeline at some point in the future we
	 * decided to implement it in Java.
	 * 
	 * TODO: If the string contains newlines these will not be taken into
	 * account, i.e. we want to maintain the newline-formatting of the source.
	 * BUT: when encountering a newline, the currentCol needs to be updated.
	 * Otherwise a line will be broken at unexpected places because the
	 * algorithm believes we're still on the same line and reaching the width.
	 * 
	 * @param input
	 *            The text to be formatted.
	 * @param width
	 *            The width
	 * @return The formatted text.
	 */
	public static String format(final String input, final String indent,
			int width) {
		final StringBuilder result = new StringBuilder();
		// the regex could be \s, but I want to preserve newlines
		// so I have to exclude them from the pattern.
		// http://download.oracle.com/javase/1.4.2/docs/api/java/util/regex/Pattern.html#predef
		final String[] chunks = input.split("[ \\t\\x0B\\f\\r]+");
		int currentCol = 0;
		for (final String chunk : chunks) {
			if (indent.length() + currentCol + chunk.length() + 1 > width) {
				removeLastChar(result);
				result.append("\n");
				result.append(indent);
				currentCol = indent.length();
			}
			result.append(chunk);
			result.append(" ");
			currentCol += chunk.length() + 1;
		}
		if (result.length() > 0) {
			removeLastChar(result);
		}
		return result.toString();
	}

	private static void removeLastChar(final StringBuilder result) {
		result.deleteCharAt(result.length() - 1);
	}

	public static String formatSbs(final String input) {
		return formatSbs(input, STD_WIDTH, "");
	}

	public static String formatSbs(final String input, int width) {
		return formatSbs(input, width, "");
	}

	/**
	 * Format one SBSForm line, using HEAD_WIDTH for space-prefixed lines that
	 * immediately follow a heading marker (y H[1-6]).
	 */
	public static String formatSbs(final String input, int width, String prevLine) {
		final int idxOfNewline = input.lastIndexOf("\n");
		if (idxOfNewline != -1 && idxOfNewline != input.length() - 1) {
			throw new RuntimeException("newline within input not "
					+ "supported. Occurs at idx:" + idxOfNewline + " in "
					+ input + " length " + input.length());
		}
		if (!input.startsWith(" ")) return input;
		int effectiveWidth = HEADING_LINE.matcher(prevLine).matches() ? HEAD_WIDTH : width;
		return format(input, " ", effectiveWidth);
	}

	public static void main(final String[] args) {
		try (BufferedReader in = new BufferedReader(new InputStreamReader(System.in))) {
			String line;
			String prevLine = "";
			if (args.length == 0) {
				while ((line = in.readLine()) != null) {
					System.out.println(formatSbs(line, STD_WIDTH, prevLine));
					prevLine = line;
				}
			}
			else {
				int width = Integer.parseInt(args[0]);
				while ((line = in.readLine()) != null) {
					System.out.println(formatSbs(line, width, prevLine));
					prevLine = line;
				}
			}
		} catch (final IOException e) {
			throw new RuntimeException(e);
		}
	}

}
