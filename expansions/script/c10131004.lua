--自由斗士·双枪的哈佛
function c10131004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10131004,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10131004)
	e1:SetCondition(c10131004.descon)
	e1:SetTarget(c10131004.destg)
	e1:SetOperation(c10131004.desop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131004,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c10131004.target)
	e2:SetOperation(c10131004.operation)
	c:RegisterEffect(e2)  
end
function c10131004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetBattleTarget() and c:GetBattleTarget():IsAbleToHand() and c:GetBattleTarget():IsControler(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c:GetBattleTarget(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c10131004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() and Duel.SendtoHand(bc,nil,REASON_EFFECT)~=0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c10131004.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x5338)
end
function c10131004.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10131004.cfilter,1,nil,tp)
end
function c10131004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10131004.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end