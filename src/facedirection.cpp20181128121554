// -*- C++ -*-
/*!
 * @file  facedirection.cpp
 * @brief ModuleDescription
 * @date $Date$
 *
 * $Id$
 */

#include "facedirection.h"

#define ERROR_CHECK( ret )											\
	if( FAILED( ret ) ){											\
		std::stringstream ss;										\
		ss << "failed " #ret " " << std::hex << ret << std::endl;	\
		return RTC::RTC_OK;				\
				}

CComPtr<IKinectSensor> kinect;

CComPtr<IColorFrameReader> colorFrameReader;
CComPtr<IBodyFrameReader> bodyFrameReader;
std::vector<BYTE> colorBuffer;
int colorWidth;
int colorHeight;
unsigned int colorBytesPerPixel;
ColorImageFormat colorFormat = ColorImageFormat::ColorImageFormat_Bgra;
cv::Mat colorImage;

std::array<CComPtr<IFaceFrameReader>, BODY_COUNT> faceFrameReader;

std::array<cv::Scalar, BODY_COUNT> colors;
std::array<std::string, FaceProperty::FaceProperty_Count> labels;
int font = cv::FONT_HERSHEY_SIMPLEX;


// Module specification
// <rtc-template block="module_spec">
static const char* facedirection_spec[] =
  {
    "implementation_id", "facedirection",
    "type_name",         "facedirection",
    "description",       "ModuleDescription",
    "version",           "1.0.0",
    "vendor",            "VenderName",
    "category",          "Category",
    "activity_type",     "PERIODIC",
    "kind",              "DataFlowComponent",
    "max_instance",      "1",
    "language",          "C++",
    "lang_type",         "compile",
    ""
  };
// </rtc-template>

/*!
 * @brief constructor
 * @param manager Maneger Object
 */
facedirection::facedirection(RTC::Manager* manager)
    // <rtc-template block="initializer">
  : RTC::DataFlowComponentBase(manager),
    m_facedirectionOut("facedirection", m_facedirection)

    // </rtc-template>
{
}

/*!
 * @brief destructor
 */
facedirection::~facedirection()
{
}



RTC::ReturnCode_t facedirection::onInitialize()
{
  // Registration: InPort/OutPort/Service
  // <rtc-template block="registration">
  // Set InPort buffers
  
  // Set OutPort buffer
  addOutPort("facedirection", m_facedirectionOut);
  
  // Set service provider to Ports
  
  // Set service consumers to Ports
  
  // Set CORBA Service Ports
  
  // </rtc-template>

  // <rtc-template block="bind_config">
  // </rtc-template>

  // Get Sensor
  ERROR_CHECK(GetDefaultKinectSensor(&kinect));

  ERROR_CHECK(kinect->Open());

  BOOLEAN isOpen;
  ERROR_CHECK(kinect->get_IsOpen(&isOpen));
  if (!isOpen){
	  throw std::runtime_error("failed IKinectSensor::get_IsOpen( &isOpen )");
  }

  // Get Color Frame Source, Open Color Frame Reader
  CComPtr<IColorFrameSource> colorFrameSource;
  ERROR_CHECK(kinect->get_ColorFrameSource(&colorFrameSource));
  ERROR_CHECK(colorFrameSource->OpenReader(&colorFrameReader));

  CComPtr<IFrameDescription> colorFrameDescription;
  ERROR_CHECK(colorFrameSource->CreateFrameDescription(colorFormat, &colorFrameDescription));
  ERROR_CHECK(colorFrameDescription->get_Width(&colorWidth));
  ERROR_CHECK(colorFrameDescription->get_Height(&colorHeight));
  ERROR_CHECK(colorFrameDescription->get_BytesPerPixel(&colorBytesPerPixel));

  colorBuffer.resize(colorWidth * colorHeight * colorBytesPerPixel);

  // Get Body Frame Source, Open Body Frame Reader
  CComPtr<IBodyFrameSource> bodyFrameSource;
  ERROR_CHECK(kinect->get_BodyFrameSource(&bodyFrameSource));
  ERROR_CHECK(bodyFrameSource->OpenReader(&bodyFrameReader));

  // Initialize Face
  DWORD features =
	  FaceFrameFeatures::FaceFrameFeatures_BoundingBoxInColorSpace
	  | FaceFrameFeatures::FaceFrameFeatures_PointsInColorSpace
	  | FaceFrameFeatures::FaceFrameFeatures_RotationOrientation
	  | FaceFrameFeatures::FaceFrameFeatures_Happy
	  | FaceFrameFeatures::FaceFrameFeatures_RightEyeClosed
	  | FaceFrameFeatures::FaceFrameFeatures_LeftEyeClosed
	  | FaceFrameFeatures::FaceFrameFeatures_MouthOpen
	  | FaceFrameFeatures::FaceFrameFeatures_MouthMoved
	  | FaceFrameFeatures::FaceFrameFeatures_LookingAway
	  | FaceFrameFeatures::FaceFrameFeatures_Glasses
	  | FaceFrameFeatures::FaceFrameFeatures_FaceEngagement;

  for (int count = 0; count < BODY_COUNT; count++){
	  // Get Face Frame Source
	  CComPtr<IFaceFrameSource> faceFrameSource;
	  ERROR_CHECK(CreateFaceFrameSource(kinect, 0, features, &faceFrameSource));

	  // Open Frace Frame Reader
	  ERROR_CHECK(faceFrameSource->OpenReader(&faceFrameReader[count]));
  }

  // Lookup Table
  colors[0] = cv::Scalar(255, 0, 0);
  colors[1] = cv::Scalar(0, 255, 0);
  colors[2] = cv::Scalar(0, 0, 255);
  colors[3] = cv::Scalar(255, 255, 0);
  colors[4] = cv::Scalar(255, 0, 255);
  colors[5] = cv::Scalar(0, 255, 255);

  return RTC::RTC_OK;
}

/*
RTC::ReturnCode_t facedirection::onFinalize()
{
  return RTC::RTC_OK;
}
*/

/*
RTC::ReturnCode_t facedirection::onStartup(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/

/*
RTC::ReturnCode_t facedirection::onShutdown(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/

/*
RTC::ReturnCode_t facedirection::onActivated(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/

/*
RTC::ReturnCode_t facedirection::onDeactivated(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/


RTC::ReturnCode_t facedirection::onExecute(RTC::UniqueId ec_id)
{
	//Color Update
	CComPtr<IColorFrame> colorFrame;
	HRESULT ret = colorFrameReader->AcquireLatestFrame(&colorFrame);
	if (FAILED(ret)){
		return RTC::RTC_OK;
	}

	ERROR_CHECK(colorFrame->CopyConvertedFrameDataToArray(static_cast<UINT>(colorBuffer.size()), &colorBuffer[0], colorFormat));

	colorImage = cv::Mat(colorHeight, colorWidth, CV_8UC4, &colorBuffer[0]);

	CComPtr<IBodyFrame> bodyFrame;
	HRESULT ret2 = bodyFrameReader->AcquireLatestFrame(&bodyFrame);
	if (FAILED(ret2)){
		return RTC::RTC_OK;
	}

	//Body Update
	std::array<CComPtr<IBody>, BODY_COUNT> bodies;
	ERROR_CHECK(bodyFrame->GetAndRefreshBodyData(BODY_COUNT, &bodies[0]));
	for (int count = 0; count < BODY_COUNT; count++){
		CComPtr<IBody> body = bodies[count];
		BOOLEAN tracked;
		ERROR_CHECK(body->get_IsTracked(&tracked));
		if (!tracked){
			continue;
		}

		// Get Tracking ID
		UINT64 trackingId;
		ERROR_CHECK(body->get_TrackingId(&trackingId));

		// Register Tracking ID
		CComPtr<IFaceFrameSource> faceFrameSource;
		ERROR_CHECK(faceFrameReader[count]->get_FaceFrameSource(&faceFrameSource));
		ERROR_CHECK(faceFrameSource->put_TrackingId(trackingId));
	}
	//Face Update
	for (int count = 0; count < BODY_COUNT; count++){
		// Get New Face Frame
		CComPtr<IFaceFrame> faceFrame;
		HRESULT ret3 = faceFrameReader[count]->AcquireLatestFrame(&faceFrame);
		if (FAILED(ret3)){
			continue;
		}

		// Check Resistration Tracking ID
		BOOLEAN tracked;
		ERROR_CHECK(faceFrame->get_IsTrackingIdValid(&tracked));
		if (!tracked){
			continue;
		}

		// Get Face Frame Result
		CComPtr<IFaceFrameResult> faceResult;
		ERROR_CHECK(faceFrame->get_FaceFrameResult(&faceResult));
		if (faceResult != nullptr){
			// Get and draw Result
			// Get and draw Point
			std::array<PointF, FacePointType::FacePointType_Count> points;
			ERROR_CHECK(faceResult->GetFacePointsInColorSpace(FacePointType::FacePointType_Count, &points[0]));
			for (const PointF p : points){
				int x = static_cast<int>(std::ceil(p.X));
				int y = static_cast<int>(std::ceil(p.Y));
				cv::circle(colorImage, cv::Point(x, y), 5, colors[count], -1, CV_AA);
			}

			// Get and DrawBounding Box
			RectI box;
			ERROR_CHECK(faceResult->get_FaceBoundingBoxInColorSpace(&box));
			int width = box.Right - box.Left;
			int height = box.Bottom - box.Top;
			cv::rectangle(colorImage, cv::Rect(box.Left, box.Top, width, height), colors[count]);

			// Get and Draw Rotation
			Vector4 quaternion;
			int pitch, yaw, roll;
			ERROR_CHECK(faceResult->get_FaceRotationQuaternion(&quaternion));

			double x = quaternion.x;
			double y = quaternion.y;
			double z = quaternion.z;
			double w = quaternion.w;

			roll = static_cast<int>(std::atan2(2 * (x * y + w * z), w * w + x * x - y * y - z * z) / M_PI * 180.0f);
			pitch = static_cast<int>(std::atan2(2 * (y * z + w * x), w * w - x * x - y * y + z * z) / M_PI * 180.0f);
			yaw = static_cast<int>(std::asin(2 * (w * y - x * z)) / M_PI * 180.0f);

			std::cout << "roll=" << roll << "[deg]" << "pitch=" << pitch << "[deg]" << "yaw=" << yaw << "[deg]" << std::endl;

			m_facedirection.data.r = roll * M_PI / 180.0f;
			m_facedirection.data.p = pitch * M_PI / 180.0f;
			m_facedirection.data.y = yaw * M_PI / 180.0f;
			m_facedirectionOut.write();

			int offset = 30;
			if (box.Left && box.Bottom){
				std::string rotationr = "Roll =" + std::to_string(roll) + "[deg]";
				std::string rotationp = "Pitch =" + std::to_string(pitch) + "[deg]";
				std::string rotationy = "Yaw =" + std::to_string(yaw) + "[deg]";

				cv::putText(colorImage, rotationr, cv::Point(box.Left, box.Bottom + offset), font, 1.0f, colors[count], 2, CV_AA);
				cv::putText(colorImage, rotationp, cv::Point(box.Left, box.Bottom + offset * 2), font, 1.0f, colors[count], 2, CV_AA);
				cv::putText(colorImage, rotationy, cv::Point(box.Left, box.Bottom + offset * 3), font, 1.0f, colors[count], 2, CV_AA);
			}
		}
	}

	// Show Face
	if (!colorImage.empty()){
		cv::imshow("Face", colorImage);
	}

	int key = cv::waitKey(10);
	if (key == VK_ESCAPE){
		cv::destroyAllWindows();
		return RTC::RTC_OK;
	}


  return RTC::RTC_OK;
}

/*
RTC::ReturnCode_t facedirection::onAborting(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/

/*
RTC::ReturnCode_t facedirection::onError(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/

/*
RTC::ReturnCode_t facedirection::onReset(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/

/*
RTC::ReturnCode_t facedirection::onStateUpdate(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/

/*
RTC::ReturnCode_t facedirection::onRateChanged(RTC::UniqueId ec_id)
{
  return RTC::RTC_OK;
}
*/



extern "C"
{
 
  void facedirectionInit(RTC::Manager* manager)
  {
    coil::Properties profile(facedirection_spec);
    manager->registerFactory(profile,
                             RTC::Create<facedirection>,
                             RTC::Delete<facedirection>);
  }
  
};


