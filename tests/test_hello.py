from hello import main


def test_hello_world_output(capsys) -> None:
    main()
    captured = capsys.readouterr()
    assert captured.out == "Hello World!\n"
