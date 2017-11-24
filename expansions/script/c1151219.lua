--运命『悲惨的命运』
function c1151219.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1151219.cost1)
	e1:SetTarget(c1151219.tg1)
	e1:SetOperation(c1151219.op1)
	c:RegisterEffect(e1)	
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
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
function c1151219.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1151219.named_with_Fulsp=1
function c1151219.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1151219.cfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER)
end
function c1151219.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1151219.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,c1151219.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CHANGE_TYPE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1_1:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e1_1,true)
	end
end
--
function c1151219.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>1 end
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
function c1151219.ofilter1_1(c)
	return c1151219.IsLeimi(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c1151219.ofilter1_2(c)
	return c1151219.IsFulan(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1151219.ofilter1_3(c)
	return c:IsAbleToHand()
end
function c1151219.ofilter1_4(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function c1151219.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>1 then
		 Duel.ConfirmDecktop(1-tp,2)
		 local g=Duel.GetDecktopGroup(1-tp,2)
		 if g:GetCount()>0 then
			if g:IsExists(c1151219.tfilter1_M,1,nil) then
				if Duel.IsExistingMatchingCard(c1151219.ofilter1_1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c1151219.ofilter1_2,tp,LOCATION_DECK,0,1,nil) then 
					local sel=Duel.SelectOption(tp,aux.Stringid(1151219,0),aux.Stringid(1151219,1))
					if sel==0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
						local g1_1=Duel.SelectMatchingCard(tp,c1151219.ofilter1_1,tp,LOCATION_DECK,0,1,1,nil)	 
						if g1_1:GetCount()>0 then
							Duel.SendtoGrave(g1_1,REASON_EFFECT)
						end
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local g1_2=Duel.SelectMatchingCard(tp,c1151219.ofilter1_2,tp,LOCATION_DECK,0,1,1,nil) 
						if g1_2:GetCount()>0 then
							Duel.SendtoHand(g1_2,nil,REASON_EFFECT)
							Duel.ConfirmCards(1-tp,g1_2)
						end
					end
				else
					if Duel.IsExistingMatchingCard(c1151219.ofilter1_1,tp,LOCATION_DECK,0,1,nil) and not Duel.IsExistingMatchingCard(c1151219.ofilter1_2,tp,LOCATION_DECK,0,1,nil) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
						local g1_1=Duel.SelectMatchingCard(tp,c1151219.ofilter1_1,tp,LOCATION_DECK,0,1,1,nil)	 
						if g1_1:GetCount()>0 then
							Duel.SendtoGrave(g1_1,REASON_EFFECT)
						end
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local g1_2=Duel.SelectMatchingCard(tp,c1151219.ofilter1_2,tp,LOCATION_DECK,0,1,1,nil) 
						if g1_2:GetCount()>0 then
							Duel.SendtoHand(g1_2,nil,REASON_EFFECT)
							Duel.ConfirmCards(1-tp,g1_2)
						end
					end
				end
			end
			if g:IsExists(c1151219.tfilter1_S,1,nil) then   
				if g:IsExists(c1151219.ofilter1_3,1,nil) then   
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g1_3=g:FilterSelect(tp,c1151219.ofilter1_3,1,1,nil)
					if g1_3:GetCount()>0 then
						Duel.SendtoHand(g1_3,tp,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g1_3)
					end
				end
			end
			if g:IsExists(c1151219.tfilter1_T,1,nil) then  
				local g1_4=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
				if g1_4:GetCount()>0 then
					Duel.ConfirmCards(tp,g1_4)
					if g1_4:IsExists(c1151219.ofilter1_4,1,nil) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
						local g1_5=Duel.SelectMatchingCard(tp,c1151219.ofilter1_4,tp,0,LOCATION_HAND,1,1,nil)
						if g1_5:GetCount()>0 then
							Duel.Remove(g1_5,POS_FACEDOWN,REASON_EFFECT)
						end
					end   
					Duel.ShuffleDeck(1-tp)
				end
			end
		end
	end
end
--
function c1151219.cfilter2(c)
	return c1151219.IsLeimi(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1151219.tfilter2(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp)
end
function c1151219.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151219.cfilter2,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsAbleToRemove() and eg:IsExists(c1151219.tfilter2,1,nil,tp) end
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