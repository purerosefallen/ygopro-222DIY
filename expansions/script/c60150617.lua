--千夜 女王
function c60150617.initial_effect(c)
	c:SetUniqueOnField(1,0,60150617)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x3b21),3,true)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c60150617.splimit)
	c:RegisterEffect(e2)
	--cannot be target/battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3b21))
	e4:SetValue(c60150617.tgvalue)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(38495396,0))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c60150617.thtg)
	e7:SetOperation(c60150617.thop)
	c:RegisterEffect(e7)
end
function c60150617.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150617.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c60150617.thfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER)
end
function c60150617.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c60150617.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60150617.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c60150617.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60150617.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_PENDULUM) and Duel.SelectYesNo(tp,aux.Stringid(60150617,0)) then
			if Duel.SendtoExtraP(tc,nil,REASON_EFFECT)>0 then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		elseif tc:IsAbleToDeck() then
			if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end