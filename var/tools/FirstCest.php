<?php

class FirstCest
{
    public function testdepartments(AcceptanceTester $I)
    {
        $I->amOnPage('/');
        $I->click('Войти');
        $I->fillField(['id' => 'login_main_login'] , 'test@mail.ru');
        $I->fillField(['id' => 'psw_main_login'] , '123456');
        $I->click('Войти'); 
        $I->amOnPage('/');
        $I->click('Мой профиль');
        $I->click('Отделы');
        $I->see('Тестовый тест');
        $I->see('departament_rename');
        $I->click('departament_rename');
        $I->see('Сотрудники отдела');
        $I->amOnPage('/');
        $I->click('Мой профиль');
        $I->amOnPage('/index.php?dispatch=auth.logout');
        $I->see('Войти');
        $I->makeHtmlSnapShot();
    }
}
