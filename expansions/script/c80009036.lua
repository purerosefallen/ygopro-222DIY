--ＤＭ 花仙兽
function c80009036.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),aux.NonTuner(Card.IsSetCard,0x2d5),1)
	c:EnableReviveLimit()   
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1) 
	--Immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c80009036.tgvalue)
	c:RegisterEffect(e4)   
	--flip
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80009036,0))
	e7:SetCategory(CATEGORY_CONTROL)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c80009036.descost)
	e7:SetTarget(c80009036.target)
	e7:SetOperation(c80009036.operation)
	c:RegisterEffect(e7)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c80009036.regcon)
	e2:SetOperation(c80009036.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80009036,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c80009036.thcon)
	e3:SetTarget(c80009036.thtg)
	e3:SetOperation(c80009036.thop)
	c:RegisterEffect(e3)
end
function c80009036.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c80009036.filter(c)
	return c:IsFaceup() and (c:IsLevelBelow(6) or c:IsRankBelow(6)) and c:IsControlerCanBeChanged()
end
function c80009036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80009036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80009036.filter,tp,0,LOCATION_MZONE,1,nil) end
	if not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c80009036.filter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
	end
end
function c80009036.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) and c80009036.filter(tc) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(tp)
		e1:SetLabel(0)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetCondition(c80009036.ctcon)
		tc:RegisterEffect(e1)
	end
end
function c80009036.ctcon(e)
	local c=e:GetOwner()
	local h=e:GetHandler()
	return (h:IsLevelBelow(6) or h:IsRankBelow(6)) and c:IsHasCardTarget(h)
end
function c80009036.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c80009036.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c80009036.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(80009036,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80009036.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(80009036)>0
end
function c80009036.thfilter(c)
	return c:IsSetCard(0x2d5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsRace(RACE_PLANT)
end
function c80009036.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80009036.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80009036.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80009036.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80009036.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end