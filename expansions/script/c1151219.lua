--运命『悲惨的命运』
function c1151219.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151219+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1151219.cost1)
	e1:SetTarget(c1151219.tg1)
	e1:SetOperation(c1151219.op1)
	c:RegisterEffect(e1)	
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1151219,2))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1151219.con2)
	e2:SetTarget(c1151219.tg2)
	e2:SetValue(c1151219.val2)
	e2:SetOperation(c1151219.op2)
	c:RegisterEffect(e2)
--
end
--
function c1151219.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151219.named_with_Leisp=1
function c1151219.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151219.cfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsReleasable()
end
function c1151219.cfilter1x(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost()
end
function c1151219.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c1151219.cfilter1,1,nil) or Duel.IsExistingMatchingCard(c1151219.cfilter1x,tp,LOCATION_GRAVE,0,2,nil) end
	if Duel.CheckReleaseGroup(tp,c1151219.cfilter1,1,nil) and not Duel.IsExistingMatchingCard(c1151219.cfilter1x,tp,LOCATION_GRAVE,0,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c1151219.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Release(g,REASON_EFFECT)
		end
	else
		if Duel.IsExistingMatchingCard(c1151219.cfilter1x,tp,LOCATION_GRAVE,0,2,nil) and not Duel.CheckReleaseGroup(tp,c1151219.cfilter1,1,nil) then	
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c1151219.cfilter1x,tp,LOCATION_GRAVE,0,2,2,nil)
			if g:GetCount()>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		else
			if Duel.IsExistingMatchingCard(c1151219.cfilter1x,tp,LOCATION_GRAVE,0,2,nil) and Duel.CheckReleaseGroup(tp,c1151219.cfilter1,1,nil) then
				local sel=Duel.SelectOption(tp,aux.Stringid(1151219,0),aux.Stringid(1151219,1))  
				if sel==0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local g=Duel.SelectMatchingCard(tp,c1151219.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
					if g:GetCount()>0 then
						Duel.Release(g,REASON_EFFECT)
					end
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local g=Duel.SelectMatchingCard(tp,c1151219.cfilter1x,tp,LOCATION_GRAVE,0,2,2,nil)
					if g:GetCount()>0 then
						Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
					end
				end
			end
		end
	end
end
--
function c1151219.tfilter1_M(c)
	return c:IsType(TYPE_MONSTER)
end
function c1151219.tfilter1_S(c)
	return c:IsType(TYPE_SPELL)
end
function c1151219.tfilter1_T(c)
	return c:IsType(TYPE_TRAP)
end
function c1151219.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>1 end
end
--
function c1151219.ofilter1x1(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToGrave()
end
function c1151219.ofilter1x2(c)
	return c:IsAbleToHand()
end
function c1151219.ofilter1x3(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsDestructable()
end
function c1151219.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>1 then
		 Duel.ConfirmDecktop(1-tp,2)
		 local g=Duel.GetDecktopGroup(1-tp,2)
		 if g:GetCount()>0 then
			if g:IsExists(c1151219.tfilter1_M,1,nil) then   
				local g1=Duel.GetMatchingGroup(c1151219.ofilter1x1,tp,LOCATION_DECK,0,nil)
				if g1:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g2=Duel.SelectMatchingCard(tp,c1151219.ofilter1x1,tp,LOCATION_DECK,0,1,1,nil)
					if g2:GetCount()>0 then
						Duel.SendtoGrave(g2,REASON_EFFECT)
					end
				end
			end
			if g:IsExists(c1151219.tfilter1_S,1,nil) then   
				if g:IsExists(c1151219.ofilter1x2,1,nil) then   
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g3=g:FilterSelect(tp,c1151219.ofilter1x2,1,1,nil)
					if g3:GetCount()>0 then
						Duel.SendtoHand(g3,tp,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g3)
					end
				end
			end
			if g:IsExists(c1151219.tfilter1_T,1,nil) then  
				local g4=Duel.GetMatchingGroup(c1151219.ofilter1x1,tp,0,LOCATION_HAND,nil)
				if g4:GetCount()>0 then
					Duel.ConfirmCards(tp,g4)
					if g4:IsExists(c1151219.ofilter1x3,1,nil) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						local g4=Duel.SelectMatchingCard(tp,c1151219.ofilter1x3,tp,0,LOCATION_HAND,1,1,nil)
						if g4:GetCount()>0 then
							Duel.Destroy(g4,REASON_EFFECT)
						end
					end   
				end
			end
		end
		Duel.ShuffleDeck(1-tp)
	end
end
--
function c1151219.cfilter2(c)
	return c1151219.IsLeimi(c) and c:IsFaceup()
end
function c1151219.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1151219.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1151219.tfilter2(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c1151219.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c1151219.tfilter2,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(1151219,2))
end
--
function c1151219.val2(e,c)
	return c1151219.tfilter2(c,e:GetHandlerPlayer())
end
--
function c1151219.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
--