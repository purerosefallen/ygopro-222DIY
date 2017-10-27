--AIW·扑克魔术的镜爱丽丝
function c66612328.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66612328,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c66612328.target)
	e1:SetOperation(c66612328.operation)
	c:RegisterEffect(e1)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66612328,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c66612328.recost)
	e4:SetTarget(c66612328.rectg)
	e4:SetOperation(c66612328.recop)
	c:RegisterEffect(e4)
end
function c66612328.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x660) or c:IsSetCard(0x666))  and c:GetLevel()>0
end 
function c66612328.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66612328.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c66612328.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SelectTarget(tp,c66612328.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c66612328.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(2)
	tc:RegisterEffect(e1)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetValue(c66612328.splimit)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end
function c66612328.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c66612328.filter2(c,e,tp)
	return c:IsCode(66612323) and c:IsAbleToHand()
end
function c66612328.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612328.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66612328.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66612328.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end