--禁弹『星弧破碎』
function c1152203.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1152203.tg1)
	e1:SetOperation(c1152203.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c1152203.con2)
	e2:SetCost(c1152203.cost2)
	e2:SetTarget(c1152203.tg2)
	e2:SetOperation(c1152203.op2)
	c:RegisterEffect(e2)
--
end
--
function c1152203.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152203.named_with_Fulsp=1
function c1152203.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulsp
end
--
function c1152203.tfilter1(c)
	return c:IsDestructable()
end
function c1152203.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_DECK)
end
--
function c1152203.ofilter1(c,code)
	return c:GetOriginalCode()==code and c:IsAbleToHand()
end
function c1152203.ofilter1_2(c)
	return c:GetOriginalCode()==1152999
end
function c1152203.ofilter1_3(c)
	return c1152203.IsFulan(c) and c:IsFaceup() and c:IsAttackPos() and c:IsType(TYPE_MONSTER)
end
function c1152203.ofilter1_4(c)
	return c:IsDestructable() and c:IsType(TYPE_MONSTER)
end
function c1152203.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1152203,5))
		if ct==2 then ac=Duel.AnnounceNumber(tp,1,2)
		else 
			if ct==3 then ac=Duel.AnnounceNumber(tp,1,2,3)
			else
				ac=Duel.AnnounceNumber(tp,1,2,3,4)
			end
		end
	end
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	if g:IsExists(c1152203.ofilter1_2,1,nil) then
		if Duel.IsExistingMatchingCard(c1152203.ofilter1_3,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1152203,1)) then
			local i=Duel.SelectOption(tp,aux.Stringid(1152212,2),aux.Stringid(1152212,3))
			if i==0 then
				if Duel.IsExistingMatchingCard(c1152003.ofilter1_4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
					local g4=Duel.GetMatchingGroup(c1152003.ofilter1_4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
					Duel.Destroy(g4,REASON_EFFECT)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
				local g5=Duel.SelectMatchingCard(tp,c1152203.ofilter1_3,tp,LOCATION_ONFIELD,0,1,1,nil)
				local tc5=g5:GetFirst()
				local g6=Duel.GetMatchingGroup(c1152003.ofilter1_4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc5)
				if g6:GetCount()>0 then
					Duel.Destroy(g6,REASON_EFFECT)
				end
			end
		else
			if Duel.SelectYesNo(tp,aux.Stringid(1152203,4)) then
				local g7=Duel.GetMatchingGroup(c1152003.ofilter1_4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
				if g7:GetCount()>0 then
					Duel.Destroy(g7,REASON_EFFECT)
				end
			end
		end
	end
	if g:IsExists(c1152203.tfilter1,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:FilterSelect(tp,c1152203.tfilter1,1,1,nil)
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			if Duel.Destroy(tc,REASON_EFFECT)~=0 and c1152203.IsFulsp(tc) and (tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP)) then
				local code=tc:GetOriginalCode()
				if Duel.IsExistingMatchingCard(c1152203.ofilter1,tp,LOCATION_DECK,0,1,nil,code) and Duel.SelectYesNo(tp,aux.Stringid(1152203,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g2=Duel.SelectMatchingCard(tp,c1152203.ofilter1,tp,LOCATION_DECK,0,1,1,nil,code)
					if g2:GetCount()>0 then
						Duel.SendtoHand(g2,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g2)
					end
				end
			end
		end
	end
end
--
function c1152203.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=tp
end
--
function c1152203.cfilter2(c)
	return c:IsAbleToRemoveAsCost() and c1152203.IsFulsp(c) and bit.band(c:GetReason(),REASON_DESTROY)~=0
end
function c1152203.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152203.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1152203.cfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
--
function c1152203.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
--
function c1152203.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(eg,REASON_EFFECT)
end
--



