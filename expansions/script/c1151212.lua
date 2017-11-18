--必杀『碎心』
function c1151212.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1151212.tg1)
	e1:SetOperation(c1151212.op1)
	c:RegisterEffect(e1)
--  
end
--
function c1151212.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151212.named_with_Leisp=1
function c1151212.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151212.tfilter1(c)
	return c1151212.IsLeimi(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1151212.tfilter1x(c)
	return (c:IsAbleToDeck() or c:IsDestructable()) and c:IsType(TYPE_MONSTER)
end
function c1151212.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c1151212.tfilter1x(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1151212.tfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c1151212.tfilter1x,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c1151212.tfilter1x,tp,0,LOCATION_ONFIELD,1,1,nil)
end
--
function c1151212.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and not tc:IsImmuneToEffect(e) then
		local code=tc:GetCode()
		if tc:IsDestructable() and not tc:IsAbleToDeck() then
			local sel=Duel.SelectOption(tp,aux.Stringid(1151212,0)) 
			if sel==0 then   
				Duel.Destroy(tc,REASON_EFFECT)
			end
		else
			if tc:IsDestructable() and tc:IsAbleToDeck() then
				local sel=Duel.SelectOption(tp,aux.Stringid(1151212,0),aux.Stringid(1151212,1))
				if sel==0 then   
					Duel.Destroy(tc,REASON_EFFECT)
				else
					Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
				end
			else
				if not tc:IsDestructable() and tc:IsAbleToDeck() then
					local sel=Duel.SelectOption(tp,aux.Stringid(1151212,1)) 
					if sel==0 then   
						Duel.SendtoDeck(tc,1,REASON_EFFECT)
					end
				end
			end
		end
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1_1:SetTargetRange(0,1)
		e1_1:SetTarget(c1151212.limit1_1)
		e1_1:SetLabel(code)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
	end
end
function c1151212.limit1_1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(e:GetLabel())
end
--
