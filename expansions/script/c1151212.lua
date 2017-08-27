--必杀『碎心』
function c1151212.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151212+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1151212.tg1)
	e1:SetOperation(c1151212.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,1151213)
	e2:SetCondition(c1151212.con2)
	e2:SetTarget(c1151212.tg2)
	e2:SetOperation(c1151212.op2)
	c:RegisterEffect(e2)
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
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
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
		local e1_2=e1_1:Clone()
		e1_2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e1_2,tp)	
		Duel.Damage(tp,800,REASON_EFFECT)
	end
end
function c1151212.limit1_1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(e:GetLabel())
end
--
function c1151212.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
--
function c1151212.tfilter2(c)
	return c:IsAbleToGrave() or c:IsAbleToDeck()
end
function c1151212.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(c1151212.tfilter2,tp,0,LOCATION_HAND,1,nil) end
end
function c1151212.op2(e,tp,eg,ep,ev,re,r,rp)
	local gn=Duel.GetFieldGroup(1-tp,0,LOCATION_HAND)
	Duel.ConfirmCards(1-tp,gn)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,c1151212.tfilter2,tp,0,LOCATION_HAND,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:IsAbleToGrave() and not tc:IsAbleToDeck() then
			local sel=Duel.SelectOption(tp,aux.Stringid(1151212,2)) 
			if sel==0 then   
				if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(1-tp,1) then
					Duel.BreakEffect()
					Duel.Draw(1-tp,1,REASON_EFFECT)
				end
			end
		else
			if tc:IsAbleToGrave() and tc:IsAbleToDeck() then
				local sel=Duel.SelectOption(tp,aux.Stringid(1151212,2),aux.Stringid(1151212,3))
				if sel==0 then   
					if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(1-tp,1) then
						Duel.BreakEffect()
						Duel.Draw(1-tp,1,REASON_EFFECT)
					end
				else
					if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(1-tp,1) then
						Duel.BreakEffect()
						Duel.Draw(1-tp,1,REASON_EFFECT)
					end
				end
			else
				if not tc:IsAbleToGrave() and tc:IsAbleToDeck() then
					local sel=Duel.SelectOption(tp,aux.Stringid(1151212,3)) 
					if sel==0 then   
						if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(1-tp,1) then
							Duel.BreakEffect()
							Duel.Draw(1-tp,1,REASON_EFFECT)
						end
					end
				end
			end
		end
	end
end
--








