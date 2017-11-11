--灵都幽冥·蓿
function c1110111.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,1110004,c1110111.filter0,1,true,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1110111)
	e1:SetCondition(c1110111.con1)
	e1:SetTarget(c1110111.tg1)
	e1:SetOperation(c1110111.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1110116)
	e2:SetTarget(c1110111.tg2)
	e2:SetOperation(c1110111.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(function(e,se,sp,st)
		return se:IsHasType(EFFECT_TYPE_ACTIONS) and c1110111.vfilter3(se:GetHandler())
	end)
	c:RegisterEffect(e3)
end
--
c1110111.named_with_Ld=1
function c1110111.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110111.filter0(c)
	return (c:IsCode(1110001) or c:IsCode(1110121))
end
--
function c1110111.vfilter3(c)
	return c1110111.IsLd(c)
end
--
function c1110111.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION 
end
--
function c1110111.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end
--
function c1110111.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.HintSelection(g)
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(e:GetHandler())
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_2:SetCode(EFFECT_DISABLE)
		e1_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_2)
		local e1_3=Effect.CreateEffect(e:GetHandler())
		e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_3:SetType(EFFECT_TYPE_SINGLE)
		e1_3:SetCode(EFFECT_DISABLE_EFFECT)
		e1_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_3)
		local e1_4=Effect.CreateEffect(e:GetHandler())
		e1_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_4:SetType(EFFECT_TYPE_SINGLE)
		e1_4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e1_4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_4)
		local e1_5=Effect.CreateEffect(e:GetHandler())
		e1_5:SetType(EFFECT_TYPE_SINGLE)
		e1_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_5:SetCode(EFFECT_CANNOT_ATTACK)
		e1_5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_5)
		local e1_6=Effect.CreateEffect(e:GetHandler())
		e1_6:SetType(EFFECT_TYPE_SINGLE)
		e1_6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1_6:SetValue(1)
		e1_6:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_6)   
		local e1_7=Effect.CreateEffect(e:GetHandler())
		e1_7:SetType(EFFECT_TYPE_SINGLE)
		e1_7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1_7:SetValue(1)
		e1_7:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_7)
		local e1_8=Effect.CreateEffect(e:GetHandler())
		e1_8:SetType(EFFECT_TYPE_SINGLE)
		e1_8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e1_8:SetValue(1)
		e1_8:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_8)
		local e1_9=Effect.CreateEffect(e:GetHandler())
		e1_9:SetType(EFFECT_TYPE_SINGLE)
		e1_9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_9:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1_9:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_9)
		local e1_10=Effect.CreateEffect(e:GetHandler())
		e1_10:SetType(EFFECT_TYPE_SINGLE)
		e1_10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1_10:SetValue(1)
		e1_10:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_10)
	end
end
--
function c1110111.filter2(c)
	return c:IsCode(1110141) and c:IsAbleToHand()
end
function c1110111.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110111.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1110111.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1110111.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
