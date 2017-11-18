--永远鲜红的幼月
function c1151001.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC_G)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c1151001.synCon)
	e0:SetOperation(c1151001.synOp)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c1151001.tg1)
	e1:SetOperation(c1151001.op1)
	c:RegisterEffect(e1)
--
end
--
c1151001.named_with_Leimi=1
function c1151001.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151001.named_with_Leisp=1
function c1151001.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
function c1151001.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1151001.named_with_Lulsp=1
function c1151001.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1151001.synLvfilter(c, syncard)
	if c:IsType(TYPE_LINK) then return 99 end
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else 
		return c:GetSynchroLevel(syncard)
	end
end

function c1151001.filter(c, tp, mg, turner, e)
	local lv = c:GetLevel() - turner:GetLevel()
	if lv < 1 then return false end
	local flag = Duel.GetLocationCountFromEx(tp, tp, turner) < 1
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SYNCHRO, tp, true, false) 
		and mg:IsExists(c1151001.matfilter, 1, turner, mg, tp, lv, c, flag)
end

function c1151001.matfilter(c, mg, tp, lv, sync, flag)
	if flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return end
	local val = c1151001.synLvfilter(c, sync)
	if val == 99 then return false end
	lv = lv - val
	if lv == 0 then return true end
	if lv > 1 then
		local g = mg:Clone()
		g:RemoveCard(c)
		return g:CheckWithSumEqual(c1151001.synLvfilter, lv, 1, 99, sync)
	end
	return false
end

function c1151001.synCon(e, c, og)
	if c == nil then return true end
	local tp = c:GetControler()
	local mg = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, c)
	return Duel.IsExistingMatchingCard(c1151001.filter, tp, LOCATION_EXTRA, 0, 1, nil, tp, mg, c, e)
end

function c1151001.synOp(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp = c:GetControler()
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, c)
	local syncG = Duel.SelectMatchingCard(tp, c1151001.filter, tp, LOCATION_EXTRA, 0, 1, 1, nil, tp, g, c, e)
	if syncG:GetCount() < 1 then return end
	sg:Merge(syncG)
	sync = syncG:GetFirst()

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SMATERIAL)
	local mg = Group.FromCards(c)
	mg:Select(tp, 1, 1, nil)
	g:RemoveCard(c)

	local lv = sync:GetLevel()-c:GetLevel()
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	local fmat = g:FilterSelect(tp, c1151001.matfilter, 1, 1, c, g, tp, lv, c, flag):GetFirst()

	local val = c1151001.synLvfilter(fmat, sync)
	mg:AddCard(fmat)
	g:RemoveCard(fmat)
	lv = lv - val

	if lv > 1 then
		local temp = g:SelectWithSumEqual(tp, c1151001.synLvfilter, lv, 1, 99, sync)
		mg:Merge(temp)
	end

	sync:SetMaterial(mg)
	Duel.SendtoGrave(mg, REASON_MATERIAL+REASON_SYNCHRO)
	sync:CompleteProcedure()
end
--
function c1151001.tfilter1(c)
	return (((c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c1151001.IsLeisp(c)) or (c:IsType(TYPE_MONSTER) and c1151001.IsFulan(c))) and c:IsAbleToHand()
end 
function c1151001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1151001.tfilter1,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(1151001)==0 end
end
--
function c1151001.ofilter1(c)
	return c:IsRace(RACE_FIEND)
end
function c1151001.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if eg:IsExists(c1151001.ofilter1,1,e:GetHandler()) and not c:IsDisabled() then
		Duel.Hint(HINT_CARD,0,1151001)
		c:RegisterFlagEffect(1151001,RESET_EVENT+0x1fe0000,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1151001.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end  
	end
end
