
class Slide{
  final String imageUrl;
  final String title;
  final String description;

  Slide({required this.imageUrl,required this.title,required this.description});
}

final slideList=[
  Slide(
      title: 'A Cool Way to Get Start',
    imageUrl: 'assets/image3.png',
      description: ' Write Some Text in future ',
  ),
  Slide(
    title: 'Easy way to Submit Your Fee',
    imageUrl: 'assets/image2.png',
    description: 'By using “Pay Online” option available in this app this is an easy way to submit your fees',
  ),
  Slide(
    title: 'A Cool Way to Get Start',
    imageUrl: 'assets/image1.png',
    description: ' Write Some Text in future ',
  )
];