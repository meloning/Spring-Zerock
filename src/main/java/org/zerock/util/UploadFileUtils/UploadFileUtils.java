package org.zerock.util.UploadFileUtils;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;
import org.zerock.util.MediaUtils.MediaUtils;

public class UploadFileUtils {
	private static final Logger logger = LoggerFactory.getLogger(UploadFileUtils.class);
	
	public static String uploadFile(String uploadPath,String originalName,byte[] fileData) throws Exception{
		//uuid로 이미지 중복 방지
		UUID uid =UUID.randomUUID();
		
		String savedName = uid.toString() + "_" + originalName;
		
		String savedPath = calcPath(uploadPath);
		
		File target = new File(uploadPath+savedPath,savedName);
		
		FileCopyUtils.copy(fileData, target);
		
		String formatName = originalName.substring(originalName.lastIndexOf(".")+1);
		
		String uploadedFileName = null;
		
		if(MediaUtils.getMediaType(formatName)!=null) {
			uploadedFileName=makeThumbnail(uploadPath,savedPath,savedName);
		}else {
			uploadedFileName=makeIcon(uploadPath,savedPath,savedName);
		}
		
		return uploadedFileName;
	}
	
	private static String makeIcon(String uploadPath,String path,String fileName)throws Exception{
		String iconName = uploadPath+path+File.separator+fileName;
		
		return iconName.substring(uploadPath.length()).replace(File.separatorChar, '/');
	}
	
	private static String calcPath(String uploadPath) {
		Calendar cal = Calendar.getInstance();
		//File.separator -> os별 경로 설정
		String yearPath = File.separator+cal.get(Calendar.YEAR);
		
		String monthPath = yearPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH)+1);
		
		String datePath = monthPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));
		
		makeDir(uploadPath,yearPath,monthPath,datePath);
		
		logger.info(datePath);
		
		return datePath;
	}
	
	private static void makeDir(String uploadPath,String...paths) {
		if(new File(uploadPath+paths[paths.length-1]).exists()) {
			return;
		}
		
		for(String path:paths) {
			File dirPath = new File(uploadPath+path);
			
			if(!dirPath.exists()) {
				dirPath.mkdir();
			}
		}
	}
	
	private static String makeThumbnail(String uploadPath,String path,String fileName)throws Exception{
		BufferedImage sourceImg = ImageIO.read(new File(uploadPath+path,fileName));
		
		//썸네일 이미지 담기
		BufferedImage destImg = Scalr.resize(sourceImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT,100);
		//썸네일 이름
		String thumbnailName = uploadPath + path + File.separator + "s_" + fileName;
		//썸네일 파일
		File newFile = new File(thumbnailName);
		
		//확장자 구하기
		String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
		
		//썸네일 이미지 생성
		ImageIO.write(destImg, formatName.toUpperCase(),newFile);
		
		//브라우저 경로에서 읽을수있도록 처리
		return thumbnailName.substring(uploadPath.length()).replace(File.separatorChar, '/');
	}
}
