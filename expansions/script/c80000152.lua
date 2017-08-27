--化石口袋妖怪 冰雪龙
function c80000152.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c80000152.indtg)
	e2:SetValue(c80000152.indval)
	c:RegisterEffect(e2)	
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c80000152.splimit)
	c:RegisterEffect(e3)
	--cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--ritual level
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_RITUAL_LEVEL)
	e5:SetValue(c80000152.rlevel)
	c:RegisterEffect(e5)  
	--effect
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80000152,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(c80000152.tg)
	e6:SetOperation(c80000152.op)
	c:RegisterEffect(e6)
	--splimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c80000152.splimit)
	c:RegisterEffect(e7)  
end
function c80000152.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80000152.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x2d0) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80000152.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x2d1) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c80000152.indfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_BATTLE)
		and (c:IsSetCard(0x2d0) and c:IsType(TYPE_MONSTER))
end
function c80000152.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80000152.indfilter,1,nil,tp) end
	return true
end
function c80000152.indval(e,c)
	return c80000152.indfilter(c,e:GetHandlerPlayer())
end
function c80000152.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80000152.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand() and c:IsSetCard(0x2d0)
end
function c80000152.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000152.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80000152.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000152.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end