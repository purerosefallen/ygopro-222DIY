--白泽球的蓝色幻想
function c22221002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22221002+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22221002.target)
	e1:SetOperation(c22221002.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22221002.cost)
	e2:SetTarget(c22221002.target2)
	e2:SetOperation(c22221002.activate2)
	c:RegisterEffect(e2)
end
c22221002.named_with_Shirasawa_Tama=1
function c22221002.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221002.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c22221002.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER)
end
function c22221002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c22221002.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22221002.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22221002.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22221002.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc) then 
			if Duel.SelectYesNo(tp,aux.Stringid(22221002,0)) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
				local sc=g:GetFirst()
				if sc then
					Duel.Remove(sc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(sc)
					e1:SetCountLimit(1)
					e1:SetOperation(c22221002.reop)
					Duel.RegisterEffect(e1,tp)
				end
			end
		end
	end
end
function c22221002.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22221002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22221002.filter2(c)
	return c22221002.IsShirasawaTama(c) and c:IsAbleToDeck()
end
function c22221002.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c22221002.filter2,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c22221002.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c22221002.filter2,tp,LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

