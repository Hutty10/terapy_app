class SliderModel {
  String? image;
  String? title;
  String? description;

  SliderModel({
    this.title,
    this.description,
    this.image,
  });

  void setImage(String getImage) {
    image = getImage;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDescription(String getDescription) {
    description = getDescription;
  }

  String getImage() {
    return image!;
  }

  String getTitle() {
    return title!;
  }

  String getDescription() {
    return description!;
  }
}

// List created
List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = SliderModel();

  // Item 1
  sliderModel.setImage("assets/images/slider_2.jpg");
  sliderModel.setTitle("Copper Articles");
  sliderModel.setDescription("Interested in buying Copper Handicrafts");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  // Item 2
  sliderModel.setImage("assets/images/slider_1.svg");
  sliderModel.setTitle("Copper 2");
  sliderModel.setDescription("Interested in buying Copper Handicrafts");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  // Item 3
  sliderModel.setImage("assets/images/slider_2.jpg");
  sliderModel.setTitle("Copper 3");
  sliderModel.setDescription("Interested in buying Copper Handicrafts");
  slides.add(sliderModel);

  sliderModel = SliderModel();
  return slides;
}
