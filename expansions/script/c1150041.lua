--蓝色世界
function c1150041.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1150041)
	e1:SetCost(c1150041.cost1)
	e1:SetTarget(c1150041.tg1)
	e1:SetOperation(c1150041.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e2:SetTarget(c1150041.tg2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--  
end
--
function c1150041.cfilter1(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToGraveAsCost()
end
function c1150041.cfilter1_1(c,code)
	return c:GetCode()==code
end
function c1150041.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local gn=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(c1150041.cfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local g2=g:Filter(c1150041.cfilter1_1,tc,tc:GetCode())
			if g2:GetCount()>0 then
				local tc2=g2:GetFirst()
				while tc2 do
					gn:AddCard(tc2)
					g:RemoveCard(tc2)
					tc2=g2:GetNext()
				end
				gn:AddCard(tc)
			end
			tc=g:GetNext()
		end
	end
	if chk==0 then return gn:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=gn:FilterSelect(tp,c1150041.cfilter1,1,1,nil)
	local tc3=g3:GetFirst()
	e:SetLabelObject(tc3)
	Duel.SendtoGrave(g3,REASON_COST)
end
--
function c1150041.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1150041.ofilter1(c,code)
	return c:GetCode()==code and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c1150041.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1150041.ofilter1,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetType(EFFECT_TYPE_FIELD)
			e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1_1:SetTargetRange(1,0)
			e1_1:SetValue(c1150041.limit1_1)
			e1_1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_1,tp)
		end
	end
end
--
function c1150041.limit1_1(e,re,tp)
	return re:GetHandler():GetType()==TYPE_SPELL and re:GetHandler():GetType()~=TYPE_CONTINUOUS and re:GetHandler():GetType()~=TYPE_EQUIP and re:GetHandler():GetType()~=TYPE_FIELD and re:GetHandler():GetType()~=TYPE_QUICKPLAY and re:GetHandler():GetType()~=TYPE_RITUAL and re:GetHandler():GetType()~=TYPE_PENDULUM and re:GetHandler():GetType()~=TYPE_UNION 
end
--
function c1150041.tfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL)
end
function c1150041.tg2(e,c)
	local g=Duel.GetMatchingGroup(c1150041.tfilter2,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	return g
end
--


