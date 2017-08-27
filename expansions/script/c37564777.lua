prim=prim or {}
function prim.se(c,at)
	local cd=c:GetOriginalCode()
	local cd1=cd*2
	local cd2=cd*3
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564777,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,cd)
	e1:SetCost(prim.sesscost(at))
	e1:SetTarget(prim.sesstg)
	e1:SetOperation(prim.sessop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(37564777,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,cd1)
	e2:SetCost(prim.SelfToHandCost(at))
	e2:SetTarget(prim.sethtg)
	e2:SetOperation(prim.sethop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,cd2)
	e3:SetTarget(prim.setg(at))
	e3:SetOperation(prim.seop(at))
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78651105,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(prim.ntcon)
	e4:SetOperation(prim.ntop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e4:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
end
function prim.SelfRemoveCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function prim.sessfilter(c,at)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and (c:IsSetCard(0x777) or c:IsAttribute(at))
end
function prim.sesscost(at)
return function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(prim.sessfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),at) end
	local g=Duel.SelectMatchingCard(tp,prim.sessfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),at)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
end
function prim.sesstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function prim.sessop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e:GetHandler():RegisterEffect(e1,true)
		end
	end
end
function prim.sethfilter(c,at)
	return (c:IsSetCard(0x777) or c:IsAttribute(at)) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function prim.SelfToHandCost(at)
return function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(prim.sethfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler(),at) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,prim.sethfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler(),at)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
end
function prim.sethtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function prim.sethop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function prim.sefilter2(c)
	return c:IsSetCard(0x777) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function prim.sefilter3(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function prim.sefilter4(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function prim.sefilter5(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function prim.sefilter(c,at,e,tp)
	if not (c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)) then return false end
	if c:IsSetCard(0x777) and Duel.IsExistingMatchingCard(prim.sefilter2,tp,LOCATION_DECK,0,1,nil) then return true end
	if c:IsAttribute(at) then
		if at==ATTRIBUTE_WIND and Duel.IsExistingMatchingCard(prim.sefilter3,tp,LOCATION_DECK,0,1,nil) then
			return true
		elseif at==ATTRIBUTE_FIRE and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			return true
		elseif at==ATTRIBUTE_EARTH and Duel.IsExistingMatchingCard(prim.sefilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			return true
		elseif at==ATTRIBUTE_WATER and Duel.IsExistingMatchingCard(prim.sefilter5,tp,LOCATION_DECK,0,1,nil,e,tp) then
			return true
		else
			return false
		end
	else 
		return false
	end
end
function prim.setg(at)
return function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(prim.sefilter,tp,LOCATION_HAND,0,1,e:GetHandler(),at,e,tp) end
	Duel.DiscardHand(tp,prim.sefilter,1,1,REASON_COST,e:GetHandler(),at,e,tp)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
	local ctg=0
	if tc:IsSetCard(0x777) then
		ctg=bit.bor(ctg,CATEGORY_REMOVE+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if tc:IsAttribute(at) then
		if at==ATTRIBUTE_WIND then
			ctg=bit.bor(ctg,CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		elseif at==ATTRIBUTE_FIRE then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			ctg=bit.bor(ctg,CATEGORY_DESTROY)
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		elseif at==ATTRIBUTE_EARTH then
			ctg=bit.bor(ctg,CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		elseif at==ATTRIBUTE_WATER then
			ctg=bit.bor(ctg,CATEGORY_TOGRAVE+CATEGORY_DECKDES)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		end
	end
	e:SetCategory(ctg)
end
end
function prim.seop(at)
return function(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	local at1=dc:GetAttribute()
	if dc and dc:IsSetCard(0x777) and Duel.IsExistingMatchingCard(prim.sefilter2,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,prim.sefilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
	if at~=at1 then return end
	if at1==ATTRIBUTE_WIND and Duel.IsExistingMatchingCard(prim.sefilter3,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,prim.sefilter3,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if at1==ATTRIBUTE_FIRE and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if at1==ATTRIBUTE_EARTH and Duel.IsExistingMatchingCard(prim.sefilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,prim.sefilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if at1==ATTRIBUTE_WATER and Duel.IsExistingMatchingCard(prim.sefilter5,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,prim.sefilter5,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
end

function prim.ntfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function prim.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local ct=0
	if lv<=4 then return false end
	if lv>4 and lv<7 then ct=1 end
	if lv>=7 then ct=2 end
	return minc<=0 and ct>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsPlayerAffectedByEffect(tp,66677708) and Duel.IsExistingMatchingCard(prim.ntfilter,tp,LOCATION_REMOVED,0,ct,nil) and Duel.GetFlagEffect(tp,66677750)==0
end
function prim.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local lv=c:GetLevel()
	local ct=0
	if lv>4 and lv<7 then ct=1 end
	if lv>=7 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,prim.ntfilter,tp,LOCATION_REMOVED,0,ct,ct,nil)
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.RegisterFlagEffect(tp,66677750,RESET_PHASE+PHASE_END,0,1)
end
function prim.sesspfilter(c,e,tp,m)
	return c:IsCode(m-10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function prim.sessrfilter(c,at)
	return c:IsAttribute(at) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(aux.TRUE,c:GetControler(),LOCATION_DECK,0,1,nil)
end
function prim.sesscfilter(c,at,sp,dr)
	if not c:IsDiscardable() or not c:IsType(TYPE_MONSTER) then return false end
	if c:IsSetCard(0x777) and dr then return true end
	if c:IsAttribute(at) and sp then return true end
	return false
end
function prim.ses(c,at)
	local m=c:GetOriginalCode()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37564777,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local spg=Duel.GetMatchingGroup(prim.sesspfilter,tp,LOCATION_DECK,0,nil,e,tp,m)
		local rmg=Duel.GetMatchingGroup(prim.sessrfilter,tp,LOCATION_DECK,0,nil,at)
		local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and spg:GetCount()>0
		local dr=Duel.IsPlayerCanDraw(tp,1) and rmg:GetCount()>0
		if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(prim.sesscfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),at,sp,dr) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,prim.sesscfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),at,sp,dr)
		local tc=g:GetFirst()
		g:AddCard(e:GetHandler())
		local l=0
		local ctg=0
		if tc:IsAttribute(at) then
			l=l+1
			ctg=ctg+CATEGORY_SPECIAL_SUMMON
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		end
		if tc:IsSetCard(0x777) then
			l=l+2
			ctg=ctg+CATEGORY_REMOVE+CATEGORY_DRAW
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		end
		e:SetCategory(ctg)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
		e:SetLabel(l)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local l=e:GetLabel()
		local b=false
		if bit.band(l,1)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,prim.sesspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,m)
			local tc=g:GetFirst()
			if tc then
				b=true
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1,true)
			end
		end
		if bit.band(l,2)~=0 and Duel.IsPlayerCanDraw(tp,1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,prim.sessrfilter,tp,LOCATION_DECK,0,1,1,nil,at)
			local tc=g:GetFirst()
			if tc then
				if b then Duel.BreakEffect() end
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				Duel.BreakEffect()
				Duel.Draw(tp,1,nil)
			end
		end
	end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37564777,2))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(0x14000)
	e2:SetCountLimit(1,m)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		if not re then return false end
		local rc=re:GetHandler()
		if not rc or not rc:IsType(TYPE_MONSTER) then return false end
		return rc:IsSetCard(0x777) or rc:IsAttribute(at)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local rmg=Duel.GetMatchingGroup(prim.sessrfilter,tp,LOCATION_DECK,0,nil,at)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and rmg:GetCount()>0 end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,prim.sessrfilter,tp,LOCATION_DECK,0,1,1,nil,at)
		local tc=g:GetFirst()
		if tc then
			if b then Duel.BreakEffect() end
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78651105,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(prim.ntcon)
	e4:SetOperation(prim.ntop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e4:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
end