--雪月华舞·怜
function c1150039.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c1150039.tg0)
	c:RegisterEffect(e0)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c1150039.con1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1150039)
	e2:SetTarget(c1150039.tg2)
	e2:SetOperation(c1150039.op2)
	c:RegisterEffect(e2)
--
end
--
function c1150039.tg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1150039.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
--
function c1150039.tfilter2(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToRemove()
end
function c1150039.tfilter2x(c)
	return c:IsAbleToRemove()
end
function c1150039.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1150039.tfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c1150039.tfilter2x,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c1150039.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c1150039.tfilter2x,tp,LOCATION_ONFIELD,0,1,1,tc1) 
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)   
end
--
function c1150039.ofilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_SPIRIT) and c:GetLevel()<5
end
function c1150039.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_SZONE) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()==2 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1150039.ofilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(1150039,0)) then
				local g2=Duel.SelectMatchingCard(tp,c1150039.ofilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g2:GetCount()>0 then
					local tc2=g2:GetFirst()
					if Duel.SpecialSummon(tc2,0,tp,tp,true,false,POS_FACEUP)~=0 then
						local e2_1=Effect.CreateEffect(e:GetHandler())
						e2_1:SetType(EFFECT_TYPE_SINGLE)
						e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
						e2_1:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
						e2_1:SetRange(LOCATION_MZONE)
						e2_1:SetReset(RESET_EVENT+0x1fe0000)
						tc2:RegisterEffect(e2_1)
					end
				end
			end
		end
	end
end


