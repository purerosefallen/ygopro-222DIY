--天罚『六芒星』
function c1151201.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1151201,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151201)
	e1:SetCost(c1151201.cost1)
	e1:SetCondition(c1151201.con1)
	e1:SetTarget(c1151201.tg1)
	e1:SetOperation(c1151201.op1)
	c:RegisterEffect(e1)		
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1151201,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_RELEASE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,1151200)
	e2:SetCondition(c1151201.con2)
	e2:SetTarget(c1151201.tg2)
	e2:SetOperation(c1151201.op2)
	c:RegisterEffect(e2)
--
end
--
function c1151201.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151201.named_with_Leisp=1
function c1151201.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151201.cfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c1151201.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c1151201.cfilter2,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c1151201.cfilter2,1,1,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_EFFECT)
	end 
end
--
function c1151201.con1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
--
function c1151201.tfilter1(c)
	return c:IsAbleToDeck()
end
function c1151201.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151201.tfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,LOCATION_ONFIELD)
end
--
function c1151201.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1151201.tfilter1,tp,0,LOCATION_ONFIELD,1,2,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
			Duel.BreakEffect()
			if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==1 then
				Duel.SortDecktop(tp,1-tp,1)
			else
				Duel.SortDecktop(tp,1-tp,2)
			end
		end 
	end
end
--
function c1151201.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp~=tp
end
--
function c1151201.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
--
function c1151201.ofilter2(c)
	return c:IsRace(RACE_FIEND)
end
function c1151201.ofilter2x(c)
	return c:IsAbleToRemove() or c:IsAbleToGrave()
end
function c1151201.ofilter2x1(c)
	return c:IsAbleToGrave()
end
function c1151201.ofilter2x2(c)
	return c:IsAbleToRemove()
end
function c1151201.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.CheckReleaseGroup(tp,c1151201.ofilter2,1,nil) and Duel.IsExistingMatchingCard(c1151201.ofilter2x,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1151201,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=Duel.SelectReleaseGroup(tp,c1151201.ofilter2,1,1,nil)
		if g2:GetCount()>0 then
			if Duel.Release(g2,REASON_EFFECT)~=0 then
				if Duel.IsExistingMatchingCard(c1151201.ofilter2x1,tp,0,LOCATION_ONFIELD,1,nil) and not Duel.IsExistingMatchingCard(c1151201.ofilter2x2,tp,0,LOCATION_ONFIELD,1,nil) then
					local sel=Duel.SelectOption(tp,aux.Stringid(1151201,3))
					if sel==0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
						local g=Duel.SelectMatchingCard(tp,c1151201.ofilter2x1,tp,0,LOCATION_ONFIELD,1,1,nil)
						if g:GetCount()>0 then
							Duel.SendtoGrave(g,REASON_EFFECT)
						end
					end
				else
					if Duel.IsExistingMatchingCard(c1151201.ofilter2x1,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c1151201.ofilter2x2,tp,0,LOCATION_ONFIELD,1,nil) then
						local sel=Duel.SelectOption(tp,aux.Stringid(1151201,3),aux.Stringid(1151201,4))
						if sel==0 then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
							local g=Duel.SelectMatchingCard(tp,c1151201.ofilter2x1,tp,0,LOCATION_ONFIELD,1,1,nil)
							if g:GetCount()>0 then
								Duel.SendtoGrave(g,REASON_EFFECT)
							end
						else
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
							local g=Duel.SelectMatchingCard(tp,c1151201.ofilter2x2,tp,0,LOCATION_ONFIELD,1,1,nil)
							if g:GetCount()>0 then
								Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
							end
						end
					else
						if not Duel.IsExistingMatchingCard(c1151201.ofilter2x1,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c1151201.ofilter2x2,tp,0,LOCATION_ONFIELD,1,nil) then 
							local sel=Duel.SelectOption(tp,aux.Stringid(1151201,4))
							if sel==0 then
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
								local g=Duel.SelectMatchingCard(tp,c1151201.ofilter2x2,tp,0,LOCATION_ONFIELD,1,1,nil)
								if g:GetCount()>0 then
									Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
								end
							end
						end
					end
				end
			end
		end
	end
end
