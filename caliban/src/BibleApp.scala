package bible.api.graphql

import zio.*

object BibleApp extends ZIOAppDefault {

  def run = for {
    _ <- Console.printLine(42)
  } yield ()

}
