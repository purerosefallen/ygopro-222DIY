--三途河畔的摆渡人
function c1156018.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156018.lcheck,1)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1156018,0))
	e2:SetType(EVENT_FREE_CHAIN+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1156018)
	e2:SetTarget(c1156018.tg2)
	e2:SetOperation(c1156018.op2)
	c:RegisterEffect(e2)
--
end
--
function c1156018.lcheck(c)
	return c:IsType(TYPE_SPIRIT)
end
--
function c1156018.tfilter2(c,e,tp,zone)
	return c:IsType(TYPE_SPIRIT) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,zone)
end
function c1156018.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return Duel.IsExistingMatchingCard(c1156018.tfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) and zone~=0 and Duel.GetTurnPlayer()==e:GetHandler():GetControler() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
--
function c1156018.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1156018)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1156018.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local code=tc:GetCode()
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP,zone)~=0 then
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e2_1:SetValue(1)
			e2_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2_1,true)
			local e2_2=Effect.CreateEffect(c)
			e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2_2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2_2,true)
		end
	end
end



